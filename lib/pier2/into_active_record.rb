require 'active_record'
require 'roo-xls'
require 'roo'

# module expects to be called in a rails framework where Active Record is already loaded and initialized and connected to the database
module Pier2
  class IntoActiveRecord
    def initialize
      @id_column_name = "id"
      @required_column_names = []
      @protected_column_names = []
      @immutable_columms = []
      @ar_class = nil
      @column_name_mapping = {}
      @error_on_protected_columns = true
      @overwrite_existing_records = false
    end

    def id_column(column_name)
      @id_column_name = column_name
    end

    def required_columns(required_column_names)
      @required_column_names = required_column_names
    end

    def protected_columns(protected_column_names)
      @protected_column_names = protected_column_names
    end

    def immutable_columms(immutable_columms)
      @immutable_columms = immutable_columms
    end

    def ar_class(ar_class_object)
      @ar_class = ar_class_object
    end

    def error_on_protected_columns(value)
      @error_on_protected_columns = value
    end

    def overwrite_existing_records(value)
      @overwrite_existing_records = value
    end

    def column_name_mapping(column_name_hash)
      @column_name_mapping.merge(column_name_hash)
    end

    def open_spreadsheet(file)
      # Basic functionality copied from http://railscasts.com/episodes/396-importing-csv-and-excel
      case File.extname(file)
      when ".csv" then Roo::CSV.new(file,{})
      when ".xls" then Roo::Excel.new(file)
      when ".xlsx" then Roo::Excelx.new(file)
      when ".ods" then Roo::OpenOffice.new(file)
      else raise "Unknown file type: #{file}"
      end
    end 

    def map_column_names(column_names)
      return column_names.map do |column_name|
        @column_name_mapping[column_name] || column_name
      end
    end

    def import_file(filename)
      spreadsheet = open_spreadsheet(filename)
      raise Pier2::TooManySheetsError, "Too many sheets" if spreadsheet.sheets.length > 1

      # Read the column names from the first row, then rename them based on the custom mapping
      header = map_column_names(spreadsheet.row(1))

      # Basic functionality copied from http://railscasts.com/episodes/396-importing-csv-and-excel
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        db_row = @ar_class.find_by_id(row["id"]) || @ar_class.new
        db_row.attributes = row.to_hash.slice(*@ar_class.column_names)
        db_row.save!

      end
    end
  end
end

