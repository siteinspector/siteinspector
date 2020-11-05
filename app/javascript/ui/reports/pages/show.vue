<template>
  <div>
    <div class="d-flex justify-content-between align-items-end">
      <h1>
        <span class="d-inline d-md-none">Report</span>
        <span class="d-none d-md-inline">Error report</span>
      </h1>
      <div>
        <IButton
          role="shareReporBtn"
          size="large"
          class="bg-white"
          type="primary"
          ghost
          @click="openShareModal"
        >
          <Icon type="md-share" />
          <span class="d-none d-md-inline"> Share Report </span>
        </IButton>
      </div>
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
import ShareForm from '../components/share'
import { Modal } from 'ui/misc/scripts/dynamic_components'

export default {
  name: 'ReportsShow',
  components: {
    Website
  },
  computed: {
    website () {
      return this.$store.getters.websites.find(e => e.slug === this.$route.params.slug)
    }
  },
  methods: {
    openShareModal () {
      Modal.open(ShareForm, {
        props: {
          website: this.website
        },
        on: {
          close: (data) => {
            Modal.remove()
          }
        }
      }, {
        title: 'Share report',
        closable: true
      })
    }
  }
}
</script>
