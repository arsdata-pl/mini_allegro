# frozen_string_literal: true

# Seed products with CSV. If it also seed Categories, Manufacturers if it is
# needed
class ParseProductCSV
  include Loggable

  private_class_method :new

  # Class method for triggerring call action directly on a class, without
  # instantiating it.
  #
  # @param file_path [String]
  # @param logging [Boolean] Enable logging
  def self.call(file_path, logging = false)
    new(file_path, logging).call
  end

  # Initialize file_path
  #
  # @param file_path [String]
  # @return object [ParseProductCSV]
  def initialize(file_path, logging)
    @file_path = file_path
    @logging = logging
  end

  # Retrieve product data from CSV.
  def call
    ReadCSV.call(file_path) do |row, row_number|
      row = format_result(row)
      persist_product(row)
      next unless (row_number % 100).zero?
      log.info("Processed #{row_number} products ...") if @logging
    end
  end

  private

  attr_reader :file_path
  attr_reader :logging
  # Due to the data we become is bloated, we get rid of unwanted characters
  #
  # @param row [CSV::Row]
  # @return row [CSV::Row] formatted
  def format_result(row)
    row.tap do |obj|
      obj['nazwa'].strip!
      obj['Kategoria'] = obj['Kategoria'].split('>').map(&:strip).reverse
    end
  end

  # Persist product based on row from CSV.
  #
  # @param row [Hash] for example {'id' => '1', 'nazwa' => 'Acme',
  # 'producent' => 'Acme Corp', 'cena' => '123', 'Kategoria' => 'A > B'}
  # @return [Product]
  def persist_product(row)
    Product.find_or_initialize_by(id: row['id'], \
                                  name: row['nazwa']) do |product|
      category = last_child_category(row['Kategoria'])
      manufacturer = Manufacturer.find_or_create_by(name: row['producent'],
                                                    code: row['kod_producenta'])
      product.add_unique_category(category)
      product.price = row['cena']
      product.manufacturer = manufacturer
      product.ean = row['ean']
      product.save!
    end
  end

  # Parse and persist category. If it has a parent category, it will bind to it.
  # Otherwise it will create one with saving the children to its parent.
  # In return we get the children category
  #
  # @param category_names [String]
  # @return child_category [Category]
  def last_child_category(category_names)
    category_names.map.with_index do |category_name, index|
      find_child_or_create_parent_category(category_names, category_name, index)
    end.first
  end

  # Find the child category based on category_names. Create parent
  #
  # @param category_names [String]
  # @param category_name [String]
  # @param index [Integer]
  #
  # @return child_category [Category]
  def find_child_or_create_parent_category(category_names, category_name, index)
    child_category = Category.find_or_create_by(name: category_name)

    unless child_category_present?(category_names, child_category, index)
      return child_category
    end

    parent_category = Category.find_or_create_by(name: category_names[index + 1])
    child_category.update(parent: parent_category)
    child_category
  end

  def child_category_present?(category_names, child_category, index)
    category_names[index + 1] && child_category.children.empty?
  end
end
