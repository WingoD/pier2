require 'minitest_helper'
require 'pier2'

class Fruit < Pier2::IntoActiveRecord
  def initialize
    super
    ar_class(Invoice)
    id_column("IdNum")
    required_columns(%w(customer_id, date, amount))
    protected_columns(%w( balance ))
    immutable_columms(%w(customer_id))
    column_name_mapping( { 'Given Name' => 'first_name', 'Sir Name' => 'last_name' } )
  end
end

class Invoice < ActiveRecord::Base
end

class TestPier2 < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pier2::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_fails_on_multiple_sheets
    assert_raises(Pier2::TooManySheetsError) { Fruit.new.import_file("test/files/two-sheets-oo.xlsx") }
    assert_raises(Pier2::TooManySheetsError) { Fruit.new.import_file("test/files/two-sheets.xlsx") }
    assert_raises(Pier2::TooManySheetsError) { Fruit.new.import_file("test/files/two-sheets.xls") }
    assert_raises(Pier2::TooManySheetsError) { Fruit.new.import_file("test/files/two-sheets.ods") }
  end
end
