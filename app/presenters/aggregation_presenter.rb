class AggregationPresenter < Struct.new(:aggregation)
  def name
    aggregation['key']
  end

  def count
    aggregation['doc_count']
  end
end
