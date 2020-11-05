<template>
  <div
    class="row mt-3"
  >
    <div class="col-12 col-lg-6">
      <b>Rule:</b> {{ conditionToText[result.custom_rule.condition] }} <code>{{ result.custom_rule.pattern }}</code>
    </div>
    <div class="col-12 col-lg-6 mt-3 mt-lg-0 border-left-0 border-lg-left">
      <div class="border-bottom border-lg-bottom-0 pb-2 pb-lg-0">
        {{ result.message }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Rule',
  props: {
    result: {
      type: Object,
      required: true
    }
  },
  computed: {
    conditionToText () {
      return {
        contain: 'Should contain',
        not_contain: 'Should not contain'
      }
    }
  },
  methods: {
  }
}
</script>
