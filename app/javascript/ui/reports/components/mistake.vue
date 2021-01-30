<template>
  <div
    :id="`page_error_${mistake.id}`"
    class="row mt-3"
    :class="{ resolved: mistake.status === 'resolved' }"
  >
    <div class="col-6 col-lg-3 d-flex align-items-center pe-1">
      <Checkbox
        v-if="editable"
        size="large"
        class="circle-checkbox"
        :model-value="mistake.status === 'resolved'"
        @on-change="updateStatus"
      />

      <div>
        <b v-if="hints">
          Error:
        </b>
        <p
          v-clipboard:copy="mistake.text"
          v-clipboard:success="onCopy"
          class="pointer-cursor"
        >
          {{ mistake.text }}
        </p>
      </div>
      <div
        style="margin-left: auto; cursor: normal"
      >
        <Icon
          type="md-arrow-round-forward"
          class="h2"
        />
      </div>
    </div>
    <div class="col-6 col-lg-3 d-flex align-items-center">
      <div>
        <b v-if="hints">
          Correction:
        </b>
        <p
          v-clipboard:copy="mistake.correction"
          v-clipboard:success="onCopy"
          class="pointer-cursor"
        >
          {{ mistake.correction }}
        </p>
      </div>
    </div>
    <div class="col-12 col-lg-6 mt-3 mt-lg-0 border-left-0 border-lg-left">
      <b v-if="hints">
        Text from the page with error:
      </b>
      <div class="border-bottom border-lg-bottom-0 pb-2 pb-lg-0 d-flex align-items-center justify-content-between">
        <Context :mistake="mistake" />
        <button
          v-if="editable"
          class="h2 ivu-btn ivu-btn-text ivu-btn-icon-only more-button"
          @click.stop="openContextMenu"
        >
          <i class="ion ion-md-more" />
        </button>
      </div>
    </div>
    <Spin
      v-if="mistake.loading"
      size="large"
      fix
    />
  </div>
</template>

<script>
import api from 'ui/api'
import Context from './context'
import MistakeMenu from './mistake_menu'
import { Popover, Message } from 'view3/src/plugins/dynamic-components'
import locale from 'ui/misc/scripts/locale'

export default {
  name: 'Mistake',
  components: {
    Context
  },
  props: {
    mistake: {
      type: Object,
      required: true
    },
    hints: {
      type: Boolean,
      required: false,
      default: false
    },
    editable: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  methods: {
    onCopy () {
      Message.info('Copied to the clipboard')
    },
    openContextMenu (event) {
      Popover.show(event.target, MistakeMenu, {
        mistake: this.mistake,
        onRemove: (type) => {
          Popover.remove()
          Message.info('Marked as false positive')
          this.$emit('remove', [this.mistake, type])
        }
      })
    },
    updateStatus (value) {
      this.mistake.status = value ? 'resolved' : 'pending'

      return api.put(`website_page_errors/${this.mistake.id}`, {
        website_page_error: {
          status: this.mistake.status
        }
      }).then((result) => {
        this.mistake.status = result.data.data.status

        if (result.data.data.status) {
          Message.info(locale.t(`marked_as_${result.data.data.status}`))
        }
      }).catch((error) => {
        console.error(error)
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.row {
  position: relative;
}

.more-button {
  width: 20px;
}

.resolved {
  opacity: 0.6;
}
</style>
