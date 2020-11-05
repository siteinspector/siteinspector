# frozen_string_literal: true

module Sidekiq
  module DynamicQueues
    DYNAMIC_QUEUE_PREFIX = 'dynamic:'

    DYNAMIC_QUEUES = ::SortedSet.new

    WATCHER = Concurrent::TimerTask.new(
      run_now: true,
      execution_interval: 5
    ) { Sidekiq::DynamicQueues.sync! }

    class Queue < Sidekiq::Queue
      def initialize(name)
        super

        @name = "#{DYNAMIC_QUEUE_PREFIX}#{name.split(':').last}"
        @rname = "queue:#{@name}"
      end

      def cleaned_name
        name.sub(DYNAMIC_QUEUE_PREFIX, '')
      end
    end

    module_function

    def setup!
      Sidekiq::Client.include(Sidekiq::DynamicPush)

      Sidekiq.configure_server do |config|
        Sidekiq.options[:fetch] = Sidekiq::DynamicFetch.new(Sidekiq.options)

        config.on(:startup) { WATCHER.execute }
        config.on(:quiet) { WATCHER.shutdown }
      end
    end

    # @return [Array<String>]
    def load_dynamic_queues
      Sidekiq.redis do |conn|
        conn.keys("queue:#{DYNAMIC_QUEUE_PREFIX}*").sort
      end
    end

    def enabled?
      Sidekiq.options[:queues].include?('dynamic')
    end

    # @return [Array<String>]
    def dynamic_queues
      DYNAMIC_QUEUES.to_a
    end

    def sync!
      DYNAMIC_QUEUES.replace(load_dynamic_queues)
    end
  end
end
