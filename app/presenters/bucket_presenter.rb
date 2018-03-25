class BucketPresenter < Struct.new(:bucket)
  def id
    formatted_bucket.first
  end

  def name
    formatted_bucket.last
  end

  def count
    bucket['doc_count']
  end

  private

  def formatted_bucket
    @formatted_bucket ||= bucket['key'].split('|')
  end
end
