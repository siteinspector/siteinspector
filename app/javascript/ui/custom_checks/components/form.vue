<template>
  <IForm
    ref="form"
    :model="formData"
    :rules="rules"
    @keyup.enter.native="handleSubmit"
  >
    <ISelect
      v-if="!rule.id && websites.length > 1"
      size="large"
      class="mb-4"
      :placeholder="'Select website'"
      filterable
      @on-change="selectedWebsiteId = $event"
    >
      <IOption
        v-for="option in websites"
        :key="option.id"
        :value="option.id"
        :label="option.domain"
      />
    </ISelect>
    <RadioGroup
      v-model="formData.condition"
      size="large"
      class="mb-3 d-flex justify-content-between"
    >
      <Radio
        label="contain"
        class="col-6 m-0 text-center"
        style="width: 49%"
        border
      >
        Contains
      </Radio>
      <Radio
        label="not_contain"
        class="col-6 m-0 text-center"
        style="width: 49%"
        border
      >
        Does not contain
      </Radio>
    </RadioGroup>
    <Divider>Pattern</Divider>
    <FormItem
      prop="pattern"
    >
      <IInput
        ref="description"
        v-model="formData.pattern"
        size="large"
        name="pattern"
        placeholder="text or /regexp/"
      />
    </FormItem>
    <Divider>On</Divider>
    <RadioGroup
      v-model="showPaths"
      size="large"
      class="mb-4 d-flex justify-content-between"
    >
      <Radio
        :label="'false'"
        class="col-6 m-0 text-center"
        style="width: 49%"
        border
      >
        Entire website
      </Radio>
      <Radio
        :label="'true'"
        class="col-6 m-0 text-center"
        style="width: 49%"
        border
      >
        Specific pages
      </Radio>
    </RadioGroup>
    <InputList
      v-if="showPaths === 'true'"
      v-model="formData.paths"
      :placeholder="'/path*'"
      :add-text="'Add Path'"
    />
    <IButton
      type="primary"
      size="large"
      long
      @click="handleSubmit()"
    >
      Submit
    </IButton>
    <Spin
      v-if="isLoading"
      size="large"
      fix
    />
  </IForm>
</template>

<script>
import api from 'ui/api'
import InputList from 'ui/misc/components/input_list'

export default {
  name: 'CustomRuleForm',
  components: {
    InputList
  },
  props: {
    rule: {
      type: Object,
      required: false,
      default: () => ({
        condition: 'contain',
        pattern: '',
        paths: ['']
      })
    }
  },
  data () {
    return {
      isLoading: false,
      showPaths: '',
      selectedWebsiteId: '',
      formData: {}
    }
  },
  computed: {
    websites () {
      return [...this.$store.getters.websites].sort((a, b) => a.domain < b.domain ? -1 : 1)
    },
    rules () {
      return {
        pattern: [{ required: true, trigger: 'blur' }]
      }
    }
  },
  mounted () {
    this.formData = { ...this.rule }
    this.showPaths = this.formData.paths[0] ? 'true' : 'false'

    if (this.websites.length === 1) {
      this.selectedWebsiteId = this.websites[0].id
    }
  },
  methods: {
    request () {
      const data = { ...this.formData }

      if (this.showPaths === 'false') {
        data.paths = []
      }

      if (this.rule.id) {
        return api.put(`custom_rules/${this.rule.id}`, {
          custom_rule: data
        })
      } else {
        return api.post(`websites/${this.selectedWebsiteId}/custom_rules`, {
          custom_rule: data
        })
      }
    },
    submit () {
      this.isLoading = true

      return this.request().then((result) => {
        this.$emit('success', result.data.data)
      }).catch((error) => {
        console.error(error)
        this.$emit('error', error)
      }).finally(() => {
        this.isLoading = false
      })
    },
    handleSubmit () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.submit()
        }
      })
    }
  }
}
</script>
