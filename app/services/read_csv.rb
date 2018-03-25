# frozen_string_literal: true

require 'csv'

# Read CSV based on file_path
class ReadCSV
  private_class_method :new

  # Class method for triggerring call action directly on a class, without
  # instantiating it.
  #
  # @param file_path [String]
  def self.call(file_path, &block)
    new(file_path).call(&block)
  end

  def initialize(file_path)
    @file_path = file_path
  end

  # Instance method that reads CSV and yields row with row number
  def call
    unless File.exist?(file_path)
      raise 'You must provide a valid location for the file'
    end
    raise 'You must provide a block!' unless block_given?
    CSV.foreach(file_path, headers: true).with_index(1) do |row, row_number|
      yield(row, row_number)
    end
  end

  private

  attr_reader :file_path
end
