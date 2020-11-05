<template>
  <div>
    <div class="d-flex justify-content-between align-items-end">
      <h1>
        Custom checks
      </h1>
      <div>
        <IButton
          size="large"
          class="bg-white"
          type="primary"
          ghost
          @click="openAddRuleModal"
        >
          <Icon type="md-add" />
          <span class="d-none d-md-inline">Add Rule</span>
        </IButton>
      </div>
    </div>
    <template v-if="isLoaded">
      <CustomRule
        v-for="customRule in customRules"
        :key="customRule.id"
        class="my-3"
        :rule="customRule"
        @update="loadRules"
      />
    </template>
    <Card
      v-else
      class="my-3"
    >
      <ContentPlaceholders
        :rounded="true"
      >
        <ContentPlaceholdersText :lines="4" />
      </ContentPlaceholders>
    </Card>
    <IButton
      size="large"
      class="mt-3"
      long
      type="dashed"
      @click="openAddRuleModal"
    >
      <Icon type="md-add" />
      Add Rule
    </IButton>
  </div>
</template>

<script>
import api from 'ui/api'
import CustomRule from '../components/custom_rule'
import CustomRuleForm from '../components/form'
import { Modal, Message } from 'ui/misc/scripts/dynamic_components'

export default {
  name: 'CustomRulesIndex',
  components: {
    CustomRule
  },
  data () {
    return {
      isSubmitted: false,
      isLoaded: false,
      customRules: []
    }
  },
  mounted () {
    this.loadRules()
  },
  methods: {
    loadRules () {
      api.get('custom_rules', {
        params: {
          include: 'results,results.website_page',
          fields: {
            website_page: 'id,url'
          }
        }
      }).then((result) => {
        this.isLoaded = true
        this.customRules = result.data.data
      }).catch((error) => {
        console.error(error)
      })
    },
    openAddRuleModal () {
      Modal.open(CustomRuleForm, {
        on: {
          success: () => {
            Modal.remove()
            Message.info('Custom check rule has been added')

            this.loadRules()
          }
        }
      }, {
        title: 'Add rule',
        closable: true
      })
    }
  }
}
</script>
