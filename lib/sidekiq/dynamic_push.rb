# frozen_string_literal: true

module Sidekiq
  module DynamicPush
    # rubocop:disable Metrics/MethodLength
    def self.included(base)
      base.class_eval do
        private

        def atomic_push(conn, payloads)
          if payloads.first.key?('at')
            conn.zadd('schedule', payloads.map do |hash|
              at = hash.delete('at').to_s
              [at, Sidekiq.dump_json(hash)]
            end)
          else
            queue = payloads.first['queue']
            now = Time.now.to_f
            to_push = payloads.map do |entry|
              entry['enqueued_at'] = now
              Sidekiq.dump_json(entry)
            end

            conn.sadd('queues', queue) unless queue.starts_with?(Sidekiq::DynamicQueues::DYNAMIC_QUEUE_PREFIX)

            conn.lpush("queue:#{queue}", to_push)
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
