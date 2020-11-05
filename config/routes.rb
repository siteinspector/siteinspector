# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, path: '/'

  root 'ui#index'

  with_options controller: 'ui' do
    resource :setup, only: %i[show]
    resource :dashboard, only: %i[show]
    resources :reports, only: %i[index show]
    resources :custom_checks, only: %i[index]
    resources :settings, only: %i[index]
  end

  resource :shared, only: %i[show], controller: 'shared_report'

  namespace :api do
    resource :setup, only: %i[create]
    resource :session, only: %i[destroy]
    resources :users, only: %i[index show update create destroy]
    resources :custom_rules, only: %i[index show update destroy]
    resources :website_resources, only: %i[update]
    resources :crawl_sessions, only: %i[show update index] do
      resource :cancel, only: %i[create], controller: 'crawl_sessions_cancel'
    end
    resources :website_page_website_resources, only: %i[update]
    resources :website_page_errors, only: %i[update] do
      resource :mark_false_positive, only: %i[create], controller: 'website_page_errors_mark_false_positive'
    end
    resources :websites, only: %i[index show create update destroy] do
      resources :crawl_sessions, only: %i[create index]
      resources :custom_rules, only: %i[index create]
      resource :active_crawl_session, only: %i[show]
      resource :report_shareable_link, only: %i[show]
      resource :report, only: %i[show]
    end
  end
end
