# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |i| "John #{i}" }
    sequence(:last_name) { |i| "Doe #{i}" }
    sequence(:email) { |i| "test#{i}@test.com" }
    sequence(:password) { |i| "testtest#{i}" }
  end

  factory :website do
    sequence(:domain) { |i| "example#{i}.com" }
    sequence(:url) { |i| "https://example#{i}.com" }
  end

  factory :custom_rule do
    website

    condition { CustomRule::CONTAIN }
    sequence(:pattern) { |i| "test #{i}" }
  end

  factory :custom_rule_result do
    website_page
    custom_rule

    sequence(:message) { |i| "Message #{i}" }
  end

  factory :website_page do
    website

    lang { 'en' }
    status { Crawler::OK }
    sha1 { SecureRandom.hex }
    sequence(:url) { |i| "https://example#{i}.com/" }
    sequence(:title) { |i| "Title #{i}" }
  end

  factory :website_page_error do
    website_page

    error_type { WebsitePageError::SPELLING }

    sequence(:text) { |i| "text #{i}" }
    sequence(:correction) { |i| "correction #{i}" }
    sequence(:context) { |i| "context #{i}" }
  end

  factory :website_resource do
    website

    status { Crawler::OK }
    resource_type { Crawler::LINK }
    sequence(:url) { |i| "https://example#{i}.com" }
    sequence(:effective_url) { |i| "https://example#{i}.com" }
  end

  factory :website_page_website_resource do
    website_page
    website_resource
  end

  factory :crawl_session do
    website
  end
end
