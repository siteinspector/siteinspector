<template>
  <span>
    {{ contextParts[0] }}<span
      v-clipboard:copy="mistake.text"
      v-clipboard:success="onCopy"
      class="text-decoration-underline pointer-cursor text-danger fw-bold"
    >{{ mistake.text }}</span>{{ contextParts[1] }}
  </span>
</template>

<script>
import { Message } from 'view3/src/plugins/dynamic-components'

export default {
  name: 'Context',
  props: {
    mistake: {
      type: Object,
      required: true
    }
  },
  computed: {
    contextParts () {
      const regexp = new RegExp(`\\b${this.mistake.text}\\b`)
      const result = this.mistake.context.split(regexp)

      if (result[0] !== this.mistake.context) {
        return result
      } else {
        return this.mistake.context.split(this.mistake.text)
      }
    }
  },
  methods: {
    onCopy () {
      Message.info('Copied to the clipboard')
    }
  }
}
</script>
