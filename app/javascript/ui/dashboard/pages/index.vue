<template>
  <div>
    <div class="d-flex justify-content-between align-items-end">
      <h1>
        Websites
      </h1>
      <div>
        <IButton
          role="addWebsiteBtn"
          size="large"
          class="bg-white"
          type="primary"
          ghost
          @click="openAddWebsiteModal"
        >
          <Icon type="md-add" />
          <span class="d-none d-md-inline">Add Website</span>
        </IButton>
      </div>
    </div>
    <Website
      v-for="website in websites"
      :key="website.id"
      class="my-3"
      :website="website"
    />
    <IButton
      role="addWebsiteBtn"
      size="large"
      class="mt-3"
      long
      type="dashed"
      @click="openAddWebsiteModal"
    >
      <Icon type="md-add" />
      Add Website
    </IButton>
  </div>
</template>

<script>
import Website from '../components/website'
import WebsiteForm from 'ui/websites/components/form'
import { Modal, Message } from 'ui/misc/scripts/dynamic_components'

export default {
  name: 'Dashboard',
  components: {
    Website
  },
  computed: {
    websites () {
      return [...this.$store.getters.websites].sort((a, b) => b.id - a.id)
    }
  },
  methods: {
    openAddWebsiteModal () {
      Modal.open(WebsiteForm, {
        on: {
          success: (website) => {
            this.$store.commit('ADD_WEBSITE', website)
            Message.success({ content: 'Website has been added successfully' })
            Modal.remove()
          },
          error: () => {
            Modal.remove()
            Message.error({ content: 'Error adding website' })
          }
        }
      }, {
        title: 'Add Website',
        closable: true
      })
    }
  }
}
</script>
