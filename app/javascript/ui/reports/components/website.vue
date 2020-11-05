<template>
  <div>
    <Card :class="{ 'pointer-cursor': collapse }">
      <div
        class="row"
        @click.prevent="toggleReport"
      >
        <div class="border-right-0 border-lg-right col-12 col-lg-3 mb-3 mb-lg-0 d-flex align-items-center justify-content-center justify-content-lg-between">
          <a
            :href="website.url"
            rel="noopener noreferrer nofollow"
            target="_blank"
          >
            <h3 class="text-break-all">
              {{ website.domain }}
            </h3>
          </a>
          <Icon
            v-if="collapse"
            :type="showReport && report.id ? 'ios-arrow-up' : 'ios-arrow-down'"
          />
        </div>
        <div class="col-12 col-lg-9">
          <div
            v-if="website.stats"
            class="row"
          >
            <div class="col-6 col-lg-3 text-center">
              <p>
                Spelling errors:
                <b>{{ numberOrNa(website.stats.spelling_mistakes) }}</b>
              </p>
            </div>
            <div class="col-6 col-lg-3 text-center">
              <p>
                Grammatical errors:
                <b>{{ numberOrNa(website.stats.grammar_mistakes) }}</b>
              </p>
            </div>
            <div class="col-6 col-lg-3 text-center mt-3 mt-lg-0">
              <p>
                Broken links:
                <b>{{ numberOrNa(website.stats.broken_links) }}</b>
              </p>
            </div>
            <div class="col-6 col-lg-3 text-center mt-3 mt-lg-0">
              <p>
                Custom checks:
                <b>{{ website.stats.custom_rules }}</b>
              </p>
            </div>
          </div>
          <ContentPlaceholders
            v-else
            :rounded="true"
          >
            <ContentPlaceholdersText :lines="1" />
          </ContentPlaceholders>
        </div>
      </div>
      <Spin
        v-if="isLoading && !report.id"
        size="large"
        fix
      />
    </Card>
    <Report
      v-if="report.id"
      :class="{ 'd-none': !showReport }"
      :show-no-errors="true"
      :report="report"
    />
    <Card
      v-else-if="!collapse"
      class="mt-3"
    >
      <ContentPlaceholders
        :rounded="true"
      >
        <ContentPlaceholdersText :lines="1" />
        <ContentPlaceholdersText :lines="4" />

        <ContentPlaceholdersText :lines="1" />
        <ContentPlaceholdersText :lines="4" />
      </ContentPlaceholders>
    </Card>
  </div>
</template>

<script>
import api from 'ui/api'
import Report from './report'

export default {
  name: 'Website',
  components: {
    Report
  },
  props: {
    collapse: {
      type: Boolean,
      required: false,
      default: false
    },
    website: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      showReport: !this.collapse,
      isLoading: false,
      report: {},
      dataWebsite: {}
    }
  },
  mounted () {
    this.dataWebsite = { ...this.website }

    if (this.collapse) {
      this.loadStats()
    } else {
      this.loadReport({ withStats: true })
    }
  },
  methods: {
    toggleReport () {
      if (this.collapse) {
        this.showReport = !this.showReport

        if (!this.report.id) {
          this.isLoading = true

          this.loadReport().finally(() => {
            this.isLoading = false
          })
        }
      }
    },
    loadReport ({ withStats } = {}) {
      return api.get(`websites/${this.website.id}/report`, {
        params: {
          include: 'pages,pages.page_errors,pages.website_page_website_resources,pages.website_page_website_resources.broken_link,pages.custom_rule_results,pages.custom_rule_results.custom_rule',
          fields: {
            custom_rule: 'id,condition,pattern,website_id',
            report: withStats ? 'pages,stats' : 'pages'
          }
        }
      }).then(result => {
        this.report = this.normalizeReport(result.data.data)
        this.report = this.sortPages(this.report)

        if (withStats) {
          this.$store.commit('UPDATE_WEBSITE', { ...this.website, stats: result.data.data.stats })
        }

        return result
      })
    },
    normalizeReport (report) {
      report.pages.forEach((page) => {
        page.broken_links = []
        page.website_page_website_resources.forEach((wpwr) => {
          if (wpwr.broken_link) {
            page.broken_links.push({
              is_resolved: wpwr.is_resolved,
              website_page_website_resource_id: wpwr.id,
              ...wpwr.broken_link
            })
          }
        })
      })

      return report
    },
    sortPages (report) {
      report.pages.sort((a, b) => {
        return (b.page_errors.length * 3 + Math.min(b.broken_links.length, 5)) - (a.page_errors.length * 3 + a.broken_links.length)
      })

      return report
    },
    loadStats () {
      api.get(`websites/${this.website.id}/report`, {
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
    numberOrNa (number) {
      return this.website.stats.pages_count === 0 ? 'N/A' : number
    }
  }
}
</script>
