# frozen_string_literal: true

module Crawler
  module LinksStore
    KEY = 'crawl:links_store'
    CACHE_STORE = ActiveSupport::Cache::MemoryStore.new
    TTL = 3.days
    REDIS_CLIENT = Redis.new(url: ENV['REDIS_URL'].presence)

    module_function

    # @param session_id [Integer]
    # @return [Array<String>]
    def all(session_id)
      REDIS_CLIENT.smembers(key_for(session_id))
    end

    # @param session_id [Integer]
    # @param link [String]
    # @return [Boolean]
    def push(session_id, link)
      link = link.downcase.delete_suffix('/')
      key = key_for(session_id)

      result = REDIS_CLIENT.sadd(key, link)

      ttl_time = CACHE_STORE.read(key)

      return result if ttl_time && ttl_time > Time.current

      ttl = REDIS_CLIENT.ttl(key)

      if ttl.negative?
        REDIS_CLIENT.expire(key, TTL)
        CACHE_STORE.write(key, Time.current + TTL.seconds)
      else
        CACHE_STORE.write(key, Time.current + ttl.seconds)
      end

      result
    end

    # @param session_id [Integer]
    # @return [Integer]
    def clear(session_id)
      REDIS_CLIENT.del(key_for(session_id))
    end

    # @param session_id [Integer]
    # @return [String]
    def key_for(session_id)
      [KEY, session_id].join(':')
    end
  end
end
