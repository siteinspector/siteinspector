<template>
  <div
    class="ivu-poptip-popper ivu-poptip"
    :class="{ 'ivu-poptip-confirm': confirm }"
  >
    <div class="ivu-poptip-content">
      <div class="ivu-poptip-arrow" />
      <div class="ivu-poptip-inner">
        <div
          class="ivu-poptip-body"
          :style="bodyStyle"
        >
          <i
            v-if="confirm"
            class="ivu-icon ivu-icon-ios-help-circle"
          />
          <div
            v-if="title"
            class="ivu-poptip-body-message"
          >
            {{ title }}
          </div>
          <slot />
        </div>
        <div
          v-if="confirm"
          class="ivu-poptip-footer"
        >
          <button
            type="button"
            class="ivu-btn ivu-btn-text ivu-btn-small"
            @click.prevent="$emit('on-cancel')"
          >
            <span>Cancel</span>
          </button>
          <button
            type="button"
            class="ivu-btn ivu-btn-primary ivu-btn-small"
            @click.prevent="$emit('on-ok')"
          >
            <span>OK</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Popover',
  props: {
    content: {
      type: String,
      required: false,
      default: ''
    },
    title: {
      type: String,
      required: false,
      default: ''
    },
    confirm: {
      type: Boolean,
      required: false,
      default: false
    },
    bodyStyle: {
      type: String,
      required: false,
      default: ''
    }
  }
}
</script>
