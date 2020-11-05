<template>
  <div v-if="!isSpin">
    <table
      v-if="crawlSessions.length"
      class="w-100 text-center"
    >
      <thead>
        <tr>
          <th width="30px" />
          <th>
            Started at
          </th>
          <th>
            Finished in
          </th>
          <th>
            Pages scanned
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="session in crawlSessions"
          :key="session.id"
        >
          <td class="text-center">
            <Tag
              :color="statusToColor[session.status]"
            >
              {{ session.status }}
            </Tag>
          </td>
          <td>
            <p class="text-break-all">
              {{ formatDate(session.created_at) }}
            </p>
          </td>
          <td>
            <p
              v-if="session.status != 'started'"
              class="text-break-all"
            >
              {{ timeDiff(session.created_at, session.updated_at) }}
            </p>
          </td>
          <td>
            {{ session.processed_count }}
          </td>
        </tr>
      </tbody>
    </table>
    <div
      v-else
      class="text-center"
    >
      <h3>The website has not been scanned yet</h3>
    </div>
  </div>
  <Spin
    v-else
    size="large"
    fix
  />
</template>

<script>
import api from 'ui/api'
import { formatDate, timeDiff } from 'ui/misc/scripts/format_date'

export default {
  name: 'WebsiteInfo',
  props: {
    website: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      isSpin: true,
      crawlSessions: []
    }
  },
  computed: {
    statusToColor () {
      return {
        completed: 'green',
        failed: 'red',
        canceled: 'orange',
        started: 'geekblue',
        created: 'volcano'
      }
    }
  },
  mounted () {
    this.loadCrawlSessions().finally(() => {
      this.isSpin = false
    })
  },
  methods: {
    timeDiff,
    formatDate (date) {
      return formatDate(date, { hour: 'numeric', minute: 'numeric', hour12: true, month: 'short', day: 'numeric' })
    },
    loadCrawlSessions () {
      return api.get(`websites/${this.website.id}/crawl_sessions`, {
      }).then((result) => {
        this.crawlSessions = result.data.data
      }).catch((error) => {
        console.error(error)
      })
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
