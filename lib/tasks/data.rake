require 'csv'

namespace :data do
  desc 'Seed product'
  task seed_csv: :environment do
    ActiveRecord::Base.transaction do
      Searchkick.disable_callbacks
      ParseProductCSV.call(ENV['FILE_PATH'], true)
      logger = Logger.new(STDOUT)
      logger.info("Done processing. Amount of products: #{Product.count}")
      logger.info("Start indexing")
      Product.reindex
      logger.info("Done indexing")
    end
  end
end
