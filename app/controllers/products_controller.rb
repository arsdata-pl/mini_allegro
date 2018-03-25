# Products Controller
class ProductsController < ApplicationController
  before_action :set_manufacturer_name
  before_action :set_category_names

  def index
    set_products_with_options
  end

  def search
    options = { fields: [:name], misspellings: true }
    aggs_where_clause = {}
    where_clause = {}

    prepare_aggregate_for_category(aggs_where_clause, options, where_clause)
    prepare_aggregate_for_manufacturer(aggs_where_clause, options,
                                       where_clause)

    set_products_with_options(where_clause, options)
    render :index
  end

  private

  def set_manufacturer_name
    @manufacturer_name = params[:filter].try(:[], :manufacturer_name)
  end

  def set_category_names
    @category_name = params[:filter].try(:[], :category_names)
  end

  # If query is not present, set to query everything
  #
  # @return query [String]
  def set_query
    query = params[:query]
    query = '*' unless query.present?
    query
  end

  # Prepares search aggregates for manufacturer
  #
  # @param aggs_where_clause [Hash] example:
  #   { category_names: {category_names: 'Foo'}}
  # @param category_name [String]
  # @param options [Hash] options for providing search query
  # @param where_clause [Hash] data for where clause for elasticsearch
  def prepare_aggregate_for_manufacturer(aggs_where_clause, options,
                                         where_clause)
    return unless @manufacturer_name.present?
    where_clause[:manufacturer_name] = @manufacturer_name
    aggs_where_clause[:manufacturer_name] = {
      manufacturer_name: @manufacturer_name
    }
    options[:aggs] ||= {}
    options[:aggs][:manufacturer_name] = {
      where: aggs_where_clause[:manufacturer_name]
    }
    options[:aggs][:category_names] = {
      where: aggs_where_clause[:manufacturer_name]
    }
  end

  # Prepares search aggregates for category
  #
  # @param aggs_where_clause [Hash] example:
  #   { category_names: {category_names: 'Foo'}}
  # @param category_name [String]
  # @param options [Hash] options for providing search query
  # @param where_clause [Hash] data for where clause for elasticsearch
  def prepare_aggregate_for_category(aggs_where_clause, options, where_clause)
    return unless @category_name.present?
    where_clause[:category_names] = @category_name
    aggs_where_clause[:category_names] = { category_names: @category_name }
    options[:aggs] ||= {}
    options[:aggs][:category_names] = {
      where: aggs_where_clause[:category_names]
    }
    options[:aggs][:manufacturer_name] = {
      where: aggs_where_clause[:category_names]
    }
  end

  # Set products with options for template. It runs search on elasticsearch
  #
  # @param where_clause [Hash]
  # @param options [Hash]
  def set_products_with_options(where_clause = {}, options = nil)
    search_options = combine_search_options(options, set_query, where_clause)
    @products = Product.search(*search_options)
    aggs = @products.aggs
    @categories = aggs['category_names']['buckets'].map do |bucket|
      AggregationPresenter.new(bucket)
    end
    @manufacturers = aggs['manufacturer_name']['buckets'].map do |bucket|
      AggregationPresenter.new(bucket)
    end
  end

  # Combine search options based on provided options, query and where clauses
  #
  # @param options [Hash] options for providing search query
  # @param query [String]
  # @param where_clause [Hash] data for where clause for elasticsearch
  def combine_search_options(options, query, where_clause)
    options[:where] = where_clause if where_clause.present?
    search_options = [query || '*',
                      includes: %i[manufacturer categories],
                      page: params[:page],
                      aggs: %i[category_names manufacturer_name],
                      per_page: 20]
    search_options[1].merge!(options) if options.present?
    search_options
  end
end
