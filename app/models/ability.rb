# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, session)
    if user
      can :manage, :all
    elsif session[:jwt_payload].present?
      website_id, role = JSON.parse(session[:jwt_payload]).values_at('wid', 'role')

      can :read, Website, id: website_id

      if role == User::EDITOR
        can :manage, WebsiteResource, website_id: website_id
        can :manage, WebsitePageError, website_page: { website_id: website_id }
        can :manage, WebsitePageWebsiteResource, website_page: { website_id: website_id }
      end
    end
  end
end
