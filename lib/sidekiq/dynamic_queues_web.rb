# frozen_string_literal: true

module Sidekiq
  module DynamicQueuesWeb
    VIEWS        = Pathname.new(__dir__).join('dynamic_queues_web')
    DYNAMIC_HTML = VIEWS.join('dynamic_queues.html.erb').read

    DynamicQueues = Sidekiq::DynamicQueues

    module_function

    def registered(app)
      Sidekiq::Web.tabs['Dynamic Queues'] = 'dynamic-queues'

      app.get('/dynamic-queues') do
        @queues =
          DynamicQueues.load_dynamic_queues.sort.map do |q|
            DynamicQueues::Queue.new(q)
          end

        erb DYNAMIC_HTML.dup
      end
    end
  end
end
