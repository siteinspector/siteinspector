<template>
  <div
    class="row"
  >
    <div class="col-6 col-lg-3 text-center">
      <p class="h1">
        {{ numberOrNa(stats.spelling_mistakes) }}
      </p>
      <p class="h3">
        Spelling errors
      </p>
      <IButton
        :to="{name: 'report', params: { slug: website.slug }}"
        type="primary"
        ghost
        class="mt-1"
      >
        Review
      </IButton>
    </div>
    <div class="col-6 col-lg-3 text-center">
      <p class="h1">
        {{ numberOrNa(stats.grammar_mistakes) }}
      </p>
      <p class="h3">
        Grammatical errors
      </p>
      <IButton
        :to="{ name: 'report', params: { slug: website.slug } }"
        type="primary"
        ghost
        class="mt-1"
      >
        Review
      </IButton>
    </div>
    <div class="col-6 col-lg-3 text-center mt-3 mt-lg-0">
      <p class="h1">
        {{ numberOrNa(stats.broken_links) }}
      </p>
      <p class="h3">
        Broken links
      </p>
      <IButton
        :to="{name: 'report', params: { slug: website.slug }}"
        type="primary"
        ghost
        class="mt-1"
      >
        Review
      </IButton>
    </div>
    <div class="col-6 col-lg-3 text-center mt-3 mt-lg-0">
      <p class="h1">
        {{ stats.custom_rules }}
      </p>
      <p class="h3">
        Custom checks
      </p>
      <IButton
        :to="{ name: 'custom_checks' }"
        type="primary"
        ghost
        class="mt-1"
      >
        Review
      </IButton>
    </div>
  </div>
</template>

<script>
export default {
  name: 'WebsiteStats',
  props: {
    website: {
      type: Object,
      required: true
    },
    stats: {
      type: Object,
      required: true
    }
  },
  methods: {
    numberOrNa (number) {
      return this.stats.pages_count === 0 ? 'N/A' : number
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
