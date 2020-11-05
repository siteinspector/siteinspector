# frozen_string_literal: true

module WebsitePages
  WITH_ERRORS_SQL = <<~SQL.squish
    EXISTS (SELECT 1 FROM website_page_errors
                     WHERE website_page_errors.website_page_id = website_pages.id
                     AND website_page_errors.error_type != 'false_positive')
    OR
    EXISTS (SELECT 1 FROM custom_rule_results
                     WHERE website_page_id = website_pages.id
                     AND custom_rule_results.deleted_at IS NULL)
    OR
    EXISTS (SELECT 1 FROM website_resources
                     JOIN website_page_website_resources
                     ON website_resources.id = website_page_website_resources.website_resource_id
                     AND website_page_website_resources.website_page_id = website_pages.id
                     AND website_resources.status != 'excluded')
  SQL

  module_function

  # @param pages [ActiveRecord::Relation<WebsitePage>]
  # @return [ActiveRecord::Relation<WebsitePage>]
  def with_errors(pages)
    pages.where(WITH_ERRORS_SQL)
  end
end
