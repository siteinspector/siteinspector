<template>
  <div>
    <div class="d-flex justify-content-between align-items-end">
      <h1>
        <span class="d-inline d-md-none">Report</span>
        <span class="d-none d-md-inline">Error report</span>
      </h1>
      <a
        href="https://www.getsiteinspector.com/"
        target="_blank"
      > SiteInspector v{{ version }} </a>
    </div>
    <Website
      :key="website.id"
      :website="website"
      class="mt-3"
    />
  </div>
</template>

<script>
import Website from '../components/website'
import VERSION from 'ui/version'

export default {
  name: 'ReportsShow',
  components: {
    Website
  },
  computed: {
    website () {
      return this.$store.getters.websites[0]
    },
    version () {
      return VERSION
    }
  }
}
</script>
