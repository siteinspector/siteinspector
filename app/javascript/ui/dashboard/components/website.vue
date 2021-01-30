<template>
  <Card>
    <div class="row">
      <div class="border-right-0 border-lg-right col-12 col-lg-3 mb-3 mb-lg-0 d-flex flex-column justify-content-between text-lg-start text-center">
        <div class="d-flex align-items-center justify-content-center justify-content-lg-between">
          <div>
            <a
              :href="website.url"
              rel="noopener noreferrer nofollow"
              target="_blank"
            >
              <h3 class="text-break-all">
                {{ website.domain }}
              </h3>
            </a>
            <Tooltip
              v-if="crawlingStarted"
              :content="`Started at ${formatTime(crawlSession.created_at)}\nQueue size: ${crawlSession.queue_size}`"
              placement="top"
            >
              <Scanning />
            </Tooltip>
          </div>
        </div>
        <div>
          <IButton
            v-if="!crawlingStarted"
            type="primary"
            :loading="isLoading"
            size="small"
            icon="md-arrow-dropright-circle"
            class="mt-1"
            @click.prevent="runCrawler"
          >
            Scan
          </IButton>
          <IButton
            v-else
            type="error"
            size="small"
            :loading="isLoading"
            ghost
            icon="md-close"
            class="mt-1"
            @click.prevent="stopCrawler"
          >
            Stop
          </IButton>
          {{ ' ' }}
          <IButton
            type="primary"
            ghost
            size="small"
            icon="md-information-circle"
            class="mt-1"
            @click.prevent="openInfoModal"
          >
            Info
          </IButton>
          {{ ' ' }}
          <IButton
            size="small"
            type="primary"
            ghost
            icon="md-settings"
            class="mt-1"
            @click.prevent="openWebsiteSettings"
          >
            Settings
          </IButton>
        </div>
      </div>
      <div class="col-12 col-lg-9">
        <Stats
          v-if="website.stats"
          :stats="website.stats"
          :website="website"
          class="row"
        />
        <ContentPlaceholders
          v-else
          style="min-height: 92px"
          :rounded="true"
        >
          <ContentPlaceholdersText :lines="4" />
        </ContentPlaceholders>
      </div>
    </div>
  </Card>
</template>

<script>
import api from 'ui/api'
import WebsiteInfo from 'ui/websites/components/info'
import WebsiteSettings from 'ui/websites/components/settings'
import Scanning from './scanning'
import Stats from './stats'
import { Drawer, Message } from 'view3/src/plugins/dynamic-components'
import { formatDate } from 'ui/misc/scripts/format_date'

export default {
  name: 'Website',
  components: {
    Stats,
    Scanning
  },
  props: {
    website: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      isLoading: false,
      crawlingStarted: false,
      crawlSession: {},
      interval: null
    }
  },
  mounted () {
    this.interval = setInterval(() => {
      if (this.crawlingStarted) {
        this.refresh()
      }
    }, 3 * 1000)

    this.loadStats()

    this.loadCrawlSession().then(() => {
      if (this.crawlSession.id) {
        this.crawlingStarted = true
      }
    })
  },
  beforeUnmount () {
    clearInterval(this.interval)
  },
  methods: {
    refresh () {
      this.loadStats()
      this.loadCrawlSession().then((result) => {
        this.crawlingStarted = !!result.data.data?.id

        if (!this.crawlingStarted) {
          Message.info(`${this.website.domain} scanning has finished`)
        }
      })
    },
    loadCrawlSession () {
      return api.get(`websites/${this.website.id}/active_crawl_session`, {
      }).then(result => {
        this.crawlSession = result.data.data || {}

        return result
      })
    },
    loadStats () {
      return api.get(`websites/${this.website.id}/report`, {
        params: {
          fields: {
            report: 'stats'
          }
        }
      }).then(result => {
        this.$store.commit('UPDATE_WEBSITE', { ...this.website, stats: result.data.data.stats })

        return result
      })
    },
    stopCrawler () {
      this.isLoading = true

      this.loadCrawlSession().then((result) => {
        if (result.data.data.id) {
          api.post(`crawl_sessions/${result.data.data.id}/cancel`, {
          }).then((result) => {
            this.isLoading = false
            this.crawlingStarted = false
          })
        } else {
          this.isLoading = false
          this.crawlingStarted = false
        }
      })

      Message.info(`${this.website.domain} scanning has been canceled`)
    },
    runCrawler () {
      this.isLoading = true

      api.post(`websites/${this.website.id}/crawl_sessions`, {
        crawl_session: { status: 'created' }
      }).then((result) => {
        this.crawlingStarted = true
        this.crawlSession = result.data.data

        Message.info(`${this.website.domain} scanning has been launched`)
      }).catch((error) => {
        console.error(error)
      }).finally(() => {
        this.isLoading = false
      })
    },
    formatTime (date) {
      return formatDate(date, { hour: 'numeric', minute: 'numeric', hour12: true })
    },
    openWebsiteSettings () {
      Drawer.open(WebsiteSettings, {
        website: this.website,
        onClose: () => {
          Drawer.remove()
        },
        onSuccess: () => {
          Drawer.remove()
        }
      }, {
        title: `${this.website.domain} settings`,
        className: 'drawer-no-bottom-padding',
        closable: true
      })
    },
    openInfoModal () {
      Drawer.open(WebsiteInfo, {
        website: this.website
      }, {
        title: `${this.website.domain} info`,
        closable: true
      })
    }
  }
}
</script>
