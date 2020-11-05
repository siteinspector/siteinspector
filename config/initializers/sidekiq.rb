# frozen_string_literal: true

require 'sidekiq/fetch'
require 'sidekiq/dynamic_push'
require 'sidekiq/dynamic_queues'
require 'sidekiq/dynamic_queues_web'

Sidekiq::DynamicQueues.setup! if Sidekiq::DynamicQueues.enabled?

Sidekiq::Web.register(Sidekiq::DynamicQueuesWeb)

Sidekiq::Web.set(:session_secret, Rails.application.secrets[:secret_key_base])
Sidekiq::Web.set(:sessions, Rails.application.config.session_options)
