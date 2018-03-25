# Provides a logging solution to stdout
module Loggable
  include ActiveSupport::Concern

  def log
    @log ||= Logger.new(STDOUT)
  end
end
