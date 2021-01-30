<template>
  <IForm
    ref="form"
    @submit.native.prevent="$emit('close')"
  >
    <div class="row">
      <FormItem
        v-if="!website && websites.length > 1"
        label="Website"
      >
        <ISelect
          :value="formData.selectedWebsiteId"
          size="large"
          :loading="formData.isLoading"
          filterable
          @on-change="onSelectWebsite"
        >
          <IOption
            v-for="option in websites"
            :key="option.id"
            :value="option.id"
            :label="option.domain"
          />
        </ISelect>
      </FormItem>
      <FormItem
        label="Link"
        class="col-12"
      >
        <IInput
          v-clipboard:copy="shareableLink"
          v-clipboard:success="onCopy"
          :model-value="shareableLink"
          :readonly="true"
          prefix="md-link"
          size="large"
        />
      </FormItem>
      <RadioGroup
        v-model="formData.selectedRole"
        size="large"
        class="mb-3 d-flex justify-content-between"
      >
        <Radio
          label="editor"
          class="col-6 m-0 text-center"
          style="width: 49%"
          border
        >
          Editor
        </Radio>
        <Radio
          label="viewer"
          class="col-6 m-0 text-center"
          style="width: 49%"
          border
        >
          Viewer
        </Radio>
      </RadioGroup>
    </div>
    <IButton
      type="primary"
      class="mt-1"
      size="large"
      long
      @click="$emit('close')"
    >
      OK
    </IButton>
  </IForm>
</template>

<script>
import api from 'ui/api'
import { Message } from 'view3/src/plugins/dynamic-components'

export default {
  name: 'ShareForm',
  props: {
    website: {
      type: Object,
      required: false,
      default: null
    }
  },
  data () {
    return {
      formData: {
        isLoading: false,
        selectedWebsiteId: '',
        selectedRole: 'editor'
      },
      shareableLinks: {}
    }
  },
  computed: {
    websites () {
      return [...this.$store.getters.websites].sort((a, b) => a.domain < b.domain ? -1 : 1)
    },
    shareableLink () {
      return this.shareableLinks[this.formData.selectedRole]
    }
  },
  mounted () {
    if (this.website) {
      this.onSelectWebsite(this.website.id)
    } else if (this.websites.length === 1) {
      this.onSelectWebsite(this.websites[0].id)
    }
  },
  methods: {
    onCopy () {
      Message.info('Copied to the clipboard')
    },
    onSelectWebsite (websiteId) {
      this.isLoading = true

      api.get(`websites/${websiteId}/report_shareable_link`, {
      }).then((result) => {
        this.shareableLinks = result.data.data
      }).catch((error) => {
        console.error(error)
      }).finally(() => {
        this.isLoading = false
      })
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
