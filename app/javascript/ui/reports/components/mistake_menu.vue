<template>
  <CellGroup @on-click="handleClick">
    <Cell
      title="False positive in context"
      name="false_positive_in_context"
    />
    <Cell
      title="Permanent false positive"
      name="permanent_false_positive"
    />
  </CellGroup>
</template>

<script>
import api from 'ui/api'

export default {
  name: 'MistakeMenu',
  props: {
    mistake: {
      type: Object,
      required: true
    }
  },
  methods: {
    handleClick (option) {
      if (['permanent_false_positive', 'false_positive_in_context'].includes(option)) {
        this.handleFalsePositive({ permanent: option === 'permanent_false_positive' })
      }
    },
    handleFalsePositive (params) {
      this.mistake.loading = true

      api.post(`website_page_errors/${this.mistake.id}/mark_false_positive`, {
        ...params
      }).then((result) => {
        this.$emit('remove', params.permanent ? 'permanent' : 'context')
      }).catch((error) => {
        console.error(error)
      })
    }
  }
}
</script>
