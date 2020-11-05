# frozen_string_literal: true

module SpringWatcherListenIgnorer
  def start
    super
    listener.ignore(/\Anode_modules/)
  end
end

Spring::Watcher::Listen.prepend(SpringWatcherListenIgnorer)

Spring.watch(
  'Gemfile.lock',
  'tmp/restart.txt',
  'tmp/caching-dev.txt',
  '.env.development'
)
