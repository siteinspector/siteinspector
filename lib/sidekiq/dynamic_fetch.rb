# frozen_string_literal: true

module Sidekiq
  class DynamicFetch < Sidekiq::BasicFetch
    FETCH_LIMIT = 30
    DYNAMIC_QUEUE_KEY = 'queue:dynamic'

    def queues_cmd
      cmd  = @queues - [DYNAMIC_QUEUE_KEY]
      cmd += Sidekiq::DynamicQueues.dynamic_queues.sample(FETCH_LIMIT).shuffle
      cmd << TIMEOUT

      cmd
    end
  end
end
