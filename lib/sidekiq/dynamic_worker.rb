# frozen_string_literal: true

module Sidekiq
  module DynamicWorker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def set(opts)
        dynamic_queue = opts.delete(:dynamic_queue)

        queue =
          "#{Sidekiq::DynamicQueues::DYNAMIC_QUEUE_PREFIX}#{dynamic_queue}"

        opts[:queue] = queue

        Sidekiq::Worker::Setter.new(self, opts)
      end
    end
  end
end
