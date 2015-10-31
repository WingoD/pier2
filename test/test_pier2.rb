require 'minitest_helper'
require 'pier2'

class ImportFruit < Pier2::IntoActiveRecord
  def initialize
    super
    ar_class(Fruit)
    id_column("IdNum")
    required_columns(%w(customer_id, date, amount))
    protected_columns(%w( balance ))
    immutable_columms(%w(customer_id))
    column_name_mapping( { 'Given Name' => 'first_name', 'Sir Name' => 'last_name' } )
  end
end

class Fruit < ActiveRecord::Base
end

class TestPier2 < Minitest::Test
  def setup
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/development.sqlite3")
    ActiveRecord::Migration.create_table "fruits" do |t|
      t.string "fruit"
      t.string "color"
      t.string "quantity"
    end
  end

  def teardown
    ActiveRecord::Migration.drop_table("fruits")
  end

  def test_that_it_has_a_version_number
    refute_nil ::Pier2::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_importing_works_at_all
    assert ImportFruit.new.import_file("test/files/fruits.csv")
    assert ImportFruit.new.import_file("test/files/fruits-oo.xlsx")
    assert ImportFruit.new.import_file("test/files/fruits.xlsx")
    assert ImportFruit.new.import_file("test/files/fruits.xls")
    assert ImportFruit.new.import_file("test/files/fruits.ods")
  end

  def test_fails_on_multiple_sheets
    assert_raises(Pier2::TooManySheetsError) { ImportFruit.new.import_file("test/files/two-sheets-oo.xlsx") }
    assert_raises(Pier2::TooManySheetsError) { ImportFruit.new.import_file("test/files/two-sheets.xlsx") }
    assert_raises(Pier2::TooManySheetsError) { ImportFruit.new.import_file("test/files/two-sheets.xls") }
    assert_raises(Pier2::TooManySheetsError) { ImportFruit.new.import_file("test/files/two-sheets.ods") }
  end
end
