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
      v-for="website in websites"
      :key="website.id"
      :website="website"
      :collapse="websites.length > 1"
      class="mt-3"
    />
  </div>
</template>

<script>
import Website from '../components/website'
import ShareForm from '../components/share'
import { Modal } from 'ui/misc/scripts/dynamic_components'

export default {
  name: 'ReportsIndex',
  components: {
    Website
  },
  computed: {
    websites () {
      return [...this.$store.getters.websites].sort((a, b) => b.id - a.id)
    }
  },
  methods: {
    openShareModal () {
      Modal.open(ShareForm, {
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
