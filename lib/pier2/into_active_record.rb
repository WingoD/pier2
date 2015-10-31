# module expects to be called in a rails framework where Active Record is already loaded and initialized and connected to the database
module Pier2
  class IntoActiveRecord
    def initialize
      @id_column_name = "id"
      @required_column_names = []
      @protected_column_names = []
      @ar_class = nil
      @column_name_mapping = {}
      @error_on_protected_columns = true
      @overwrite_existing_records = false
    end

    def import(filename)
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path,{})
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end 

    def map_column_names(column_names)
      return map column_names do |column_name|
        @column_name_mapping[column_name] || column_name
      end
    end

    def import_file(filename)
      spreadsheet = open_spreadsheet(filename)

      # Read the column names from the first row, then rename them based on the custom mapping
      header = map_column_names(spreadsheet.row(1))

      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        db_row = @ar_class.find_by_id(row["id"]) || @ar_class.new
        db_row.attributes = row.to_hash.slice(*accessible_attributes)
        db_row.save!

      end
    end

  end
end

