module BackgrounDRb
  class MetaWorker
    class << self
      def set_worker_name(symbol)
      end
    end
    
    def initialize
      @logger ||= Logger.new(STDOUT)
      @logger.level = Logger::ERROR
    end
  end
end
