# frozen_string_literal: true

# == Schema Information
#
# Table name: crawl_sessions
#
#  id              :bigint           not null, primary key
#  enqueued_count  :integer          default(0), not null
#  error_count     :integer          default(0), not null
#  processed_count :integer          default(0), not null
#  status          :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  website_id      :bigint           not null
#
# Indexes
#
#  index_crawl_sessions_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => websites.id)
#
class CrawlSession < ApplicationRecord
  STATUSES = [
    CREATED = 'created',
    COMPLETED = 'completed',
    FAILED = 'failed',
    CANCELED = 'canceled',
    STARTED = 'started'
  ].freeze

  belongs_to :website

  attribute :status, :string, default: CREATED

  def started?
    status == STARTED
  end

  def finished?
    return false if processed_count.zero?

    self.class.where(id: id).where('enqueued_count = error_count + processed_count').exists?
  end
end
