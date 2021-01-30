<template>
  <Card
    v-if="totalErrors"
    :id="`page${page.id}`"
  >
    <div class="mb-3">
      <Affix>
        <div
          class="h3 link-header"
          style="background-color: white; width: 100%"
        >
          <b v-if="hints && withCounters && (page.broken_links.length || page.page_errors.length)">
            {{ totalErrors }} error{{ totalErrors > 1 ? 's' : '' }} on:
          </b>
          <b v-else-if="hints">
            Page:
          </b>
          <a
            class="fw-bold text-break-all"
            rel="noopener noreferrer nofollow"
            target="_blank"
            :href="page.url"
          >
            <span>
              {{ page.url }}
            </span>
            {{ ' ' }}
            <Icon
              type="md-open"
              class="h2"
            />
          </a>
        </div>
      </Affix>
    </div>
    <div
      v-if="customRuleResults.length"
      class="mt-3"
    >
      <Divider>Custom checks</Divider>
      <Rule
        v-for="result in page.custom_rule_results"
        :key="result.id"
        :result="result"
      />
    </div>
    <div
      v-if="spellingMistakes.length"
    >
      <Divider>Spelling errors</Divider>
      <Mistake
        v-for="(mistake, index) in spellingMistakes"
        :key="mistake.id"
        :editable="$store.getters.canEdit"
        class="mt-3"
        :hints="hints && index === 0"
        :mistake="mistake"
        @remove="$emit('remove', $event)"
      />
    </div>
    <div
      v-if="grammarMistakes.length"
    >
      <Divider>Grammatical errors</Divider>
      <Mistake
        v-for="(mistake, index) in grammarMistakes"
        :key="mistake.id"
        :editable="$store.getters.canEdit"
        class="mt-3"
        :hints="hints && index === 0"
        :mistake="mistake"
        @remove="$emit('remove', $event)"
      />
    </div>
    <div
      v-if="page.broken_links && brokenLinks.length"
      class="mt-3"
    >
      <Divider>Broken links</Divider>
      <Link
        v-for="link in limitedBrokenLinks"
        :key="link.id"
        :editable="$store.getters.canEdit"
        class="mt-2"
        :link="link"
        :page="page"
        @update-resolved="link.is_resolved = $event"
        @update-status="link.status = $event"
      />
      <div
        v-if="limitedBrokenLinks.length < brokenLinks.length"
        class="text-center mt-3"
      >
        <IButton
          size="large"
          class="d-block w-100"
          type="dashed"
          @click.prevent="showAllLinks = true"
        >
          Show all links
        </IButton>
      </div>
    </div>
  </Card>
</template>

<script>
import Mistake from './mistake'
import Link from './link'
import Rule from './rule'

export default {
  name: 'ReportItem',
  components: {
    Mistake,
    Link,
    Rule
  },
  props: {
    page: {
      type: Object,
      required: true
    },
    withCounters: {
      type: Boolean,
      required: false,
      default: false
    },
    hints: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  data () {
    return {
      showAllLinks: false
    }
  },
  computed: {
    brokenLinks () {
      return this.page.broken_links
        .filter((l) => l.status !== 'excluded')
        .sort((a, b) => a.id - b.id)
    },
    limitedBrokenLinks () {
      const links = this.brokenLinks

      if (this.showAllLinks) {
        return links
      } else {
        if (links.length > 5 && links.length < 8) {
          return links
        } else {
          return links.slice(0, 5)
        }
      }
    },
    totalErrors () {
      return this.spellingMistakes.length + this.page.broken_links.length + this.grammarMistakes.length + this.customRuleResults.length
    },
    customRuleResults () {
      return this.page.custom_rule_results
    },
    spellingMistakes () {
      const types = ['spelling', 'duplicate']

      return this.page.page_errors.filter((e) => {
        return types.includes(e.error_type)
      }).sort((a, b) => a.id - b.id)
    },
    grammarMistakes () {
      return this.page.page_errors.filter((e) => {
        return e.error_type === 'grammar'
      }).sort((a, b) => a.id - b.id)
    }
  }
}
</script>

<style lang="scss" scoped>
@import 'ui/misc/styles/breakpoints.scss';

/deep/

.link-header {
  min-height: 30px;
  max-height: 30px;
  overflow: hidden;
}

.ivu-affix .link-header {
  border-bottom: 1px solid #dee2e6;

  a {
    overflow: hidden;
  }
}

@media (max-width: $breakpoint-md) {
  .link-header {
    overflow: hidden;
    min-height: 55px;
    max-height: 55px;
  }
}
@media (max-width: $breakpoint-se) {
  .link-header {
    min-height: 45px;
    max-height: 45px;
  }
}
</style>
