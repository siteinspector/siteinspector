<template>
  <Card>
    <div class="d-flex justify-content-between">
      <p
        class="h2 fw-bold text-break-all"
      >
        <a
          :href="website.url"
          target="_blank"
        >
          {{ website.domain }}
        </a>
        {{ conditionToText[rule.condition] }} <code>{{ rule.pattern }}</code>
      </p>

      <div>
        <Tooltip
          :content="'Edit'"
          placement="top"
        >
          <IButton
            icon="md-create"
            type="text"
            class="h3"
            size="small"
            @click="openUpdateModal"
          />
        </Tooltip>
        <Tooltip
          :content="'Remove'"
          placement="top"
        >
          <IButton
            icon="md-trash"
            type="text"
            class="h3"
            size="small"
            @click="removeRule"
          />
        </Tooltip>
      </div>
    </div>
    <div
      v-if="results.length === 0"
      class="text-center h3"
    >
      <Icon
        type="md-checkmark-circle-outline h2"
        :color="'green'"
      /> No errors found
    </div>
    <div
      v-for="result in limitedResults"
      :key="result.id"
      class="row my-2"
    >
      <div class="border-right-0 border-lg-right col-12 col-lg-6 mb-3 mb-lg-0 d-flex align-items-center">
        <a
          :href="result.website_page.url"
          class="text-break-all"
          rel="noopener noreferrer nofollow"
          target="_blank"
        >
          <span>{{ result.website_page.url }}</span>
          <Icon type="md-open" />
        </a>
      </div>
      <div class="col-12 col-lg-6">
        <p v-if="results.length < 2">
          {{ rule.description }}
        </p>
        <div
          v-if="result"
          class="my-2"
        >
          {{ result.message }}
        </div>
      </div>
    </div>
    <div
      v-if="limitedResults.length < results.length"
      class="text-center mt-3"
    >
      <IButton
        size="large"
        class="d-block w-100"
        type="dashed"
        @click.prevent="showAllResults = true"
      >
        Show all ({{ results.length }})
      </IButton>
    </div>
  </Card>
</template>

<script>
import api from 'ui/api'
import CustomRuleForm from '../components/form'
import { Modal, Message, Dialog } from 'view3/src/plugins/dynamic-components'

export default {
  name: 'CustomRule',
  props: {
    rule: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      showAllResults: false
    }
  },
  computed: {
    conditionToText () {
      return {
        contain: 'should contain',
        not_contain: 'should not contain'
      }
    },
    limitedResults () {
      if (this.showAllResults) {
        return this.results
      } else {
        if (this.results.length > 5 && this.results.length < 8) {
          return this.results
        } else {
          return this.results.slice(0, 5)
        }
      }
    },
    results () {
      return this.rule.results
    },
    website () {
      return this.$store.getters.websites.find((ws) => ws.id === this.rule.website_id)
    }
  },
  methods: {
    removeRule () {
      Dialog.confirm({
        title: 'Are you sure?',
        closable: true,
        onOk: () => {
          api.delete(`custom_rules/${this.rule.id}`).then(() => {
            Message.info('Custom check rule has been removed')

            this.$emit('update')
          }).catch((error) => {
            console.error(error)
            Message.error('Unable to perform this action')
          })
        }
      })
    },
    openUpdateModal () {
      Modal.open(CustomRuleForm, {
        rule: this.rule,
        onSuccess: (rule) => {
          Modal.remove()

          Message.info('Custom check rule has been updated')

          this.$emit('update', rule)
        }
      }, {
        title: 'Update rule',
        closable: true
      })
    }
  }
}
</script>
