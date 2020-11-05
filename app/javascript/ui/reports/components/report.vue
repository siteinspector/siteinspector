<template>
  <div v-if="report.pages.length > 0">
    <ReportItem
      v-for="page in report.pages"
      :key="page.id"
      :hints="true"
      :page="page"
      class="mt-3"
      @remove="removeMistake"
    />
    <Divider :key="report.id" />
  </div>
  <div
    v-else-if="showNoErrors"
    class="h1 text-center mt-3"
  >
    There are no errors found
  </div>
</template>

<script>
import ReportItem from './item'

export default {
  name: 'Report',
  components: {
    ReportItem
  },
  props: {
    report: {
      type: Object,
      required: true
    },
    paywallIndex: {
      type: Number,
      required: false,
      default: 2
    },
    showNoErrors: {
      type: Boolean,
      required: false,
      default: false
    },
    timeline: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  methods: {
    removeMistake ([mistake, type]) {
      this.report.pages.forEach((page) => {
        page.page_errors.forEach((err, index) => {
          if ((type === 'context' && err.text === mistake.text && err.context === mistake.context) ||
              (type === 'permanent' && err.text === mistake.text)) {
            page.page_errors.splice(index, 1)
          }
        })
      })
    }
  }
}
</script>
