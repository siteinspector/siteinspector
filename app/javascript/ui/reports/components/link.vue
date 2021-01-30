<template>
  <div
    :id="`resource_${link.id}`"
    :class="{ resolved: link.is_resolved }"
  >
    <Checkbox
      v-if="editable"
      size="large"
      class="circle-checkbox"
      :value="link.is_resolved"
      @on-change="updateStatus"
    />

    <Tag
      v-popover="{ confirm: true, title: 'Do now show this link again?', onOnOk: excludeLink, trigger: 'click', disabled: !editable }"
      :color="statusClasses[link.status]"
    >
      {{ statusToText[link.status] }}
    </Tag>

    <a
      :href="link.status === 'invalid' ? 'javascript:void(0)' : link.effective_url"
      class="text-break-all"
      rel="noopener noreferrer nofollow"
      target="_blank"
    > {{ link.url }}</a>
  </div>
</template>

<script>
import api from 'ui/api'
import locale from 'ui/misc/scripts/locale'
import { Message } from 'view3/src/plugins/dynamic-components'

export default {
  name: 'Link',
  props: {
    link: {
      type: Object,
      required: true
    },
    page: {
      type: Object,
      required: true
    },
    editable: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  data () {
    return {
      status: 'pending'
    }
  },
  computed: {
    statusToText () {
      return {
        not_found: 'Not Found',
        invalid: 'Invalid',
        unavailable: 'Unavailable',
        unknown: 'Unavailable',
        broken: 'Broken',
        ok: 'OK'
      }
    },
    statusClasses () {
      return {
        not_found: 'warning',
        unavailable: 'warning',
        unknown: 'warning',
        invalid: 'error'
      }
    }
  },
  methods: {
    t: locale.t,
    excludeLink () {
      this.$emit('update-status', 'excluded')

      return api.put(`website_resources/${this.link.id}`, {
        website_resource: {
          status: 'excluded'
        }
      }).then((result) => {
        Message.info(locale.t('marked_as_excluded'))
      }).catch((error) => {
        console.error(error)
      })
    },
    updateStatus (value) {
      this.$emit('update-resolved', value)

      return api.put(`website_page_website_resources/${this.link.website_page_website_resource_id}`, {
        website_page_website_resource: {
          is_resolved: this.link.is_resolved
        }
      }).then((result) => {
        if (value) {
          Message.info(locale.t('marked_as_resolved'))
        } else {
          Message.info(locale.t('marked_as_pending'))
        }
      }).catch((error) => {
        console.error(error)
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.resolved {
  opacity: 0.6;
}
</style>
