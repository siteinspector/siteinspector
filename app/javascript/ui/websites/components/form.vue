<template>
  <IForm
    ref="form"
    :model="website"
    :rules="rules"
    @keyup.enter.native="handleSubmit"
  >
    <FormItem prop="domain">
      <IInput
        v-model="website.domain"
        prefix="md-link"
        type="text"
        size="large"
        placeholder="URL or domain"
      />
    </FormItem>
    <Collapse simple>
      <Panel name="1">
        Configure
        <template #content>
          <Divider>Exclude paths</Divider>
          <InputList
            v-model="website.preferences.exclude_paths"
            :placeholder="'/path*'"
          />
          <FormItem label="Start from path">
            <IInput v-model="website.preferences.start_path" />
          </FormItem>
          <Divider>Website checks</Divider>
          <div class="row">
            <div class="col-6 ivu-form-item">
              <ISwitch
                v-model="website.preferences.check_spelling_and_grammar"
                size="large"
              >
                <template #open>
                  On
                </template>
                <template #close>
                  Off
                </template>
              </ISwitch>
              {{ ' ' }}
              <label>Spelling and grammar</label>
            </div>
            <div class="col-6 ivu-form-item">
              <ISwitch
                v-model="website.preferences.check_links"
                size="large"
              >
                <template #open>
                  On
                </template>
                <template #close>
                  Off
                </template>
              </ISwitch>
              {{ ' ' }}
              <label>Links</label>
            </div>
            <div class="col-6 ivu-form-item">
              <ISwitch
                v-model="website.preferences.check_images"
                size="large"
              >
                <template #open>
                  On
                </template>
                <template #close>
                  Off
                </template>
              </ISwitch>
              {{ ' ' }}
              <label>Images</label>
            </div>
            <div class="col-6 ivu-form-item">
              <ISwitch
                v-model="website.preferences.check_scripts"
                size="large"
              >
                <template #open>
                  On
                </template>
                <template #close>
                  Off
                </template>
              </ISwitch>
              {{ ' ' }}
              <label>Scripts</label>
            </div>
          </div>
        </template>
      </Panel>
    </Collapse>
    <IButton
      type="primary"
      size="large"
      class="mt-1"
      long
      @click="handleSubmit()"
    >
      {{ submitText }}
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
  name: 'WebsiteForm',
  components: {
    InputList
  },
  props: {
    startCrawl: {
      type: Boolean,
      required: false,
      default: false
    },
    submitText: {
      type: String,
      required: false,
      default: 'Submit'
    }
  },
  data () {
    return {
      isLoading: false,
      website: {
        domain: '',
        preferences: {
          start_path: '/',
          exclude_paths: [],
          check_spelling_and_grammar: true,
          check_links: true,
          check_images: false,
          check_scripts: false,
          exclude_xpath: ''
        }
      }
    }
  },
  computed: {
    rules () {
      return {
        domain: [{ required: true, trigger: 'blur' }]
      }
    }
  },
  methods: {
    submit () {
      this.isLoading = true

      return api.post('websites', {
        website: this.website
      }).then((result) => {
        if (this.startCrawl) {
          this.runCrawler(result.data.data)
        } else {
          this.isLoading = false
          this.$emit('success', result.data.data)
        }
      }).catch((error) => {
        this.isLoading = false
        console.error(error)
        this.$emit('error', error)
      }).finally(() => {
        this.isLoading = false
      })
    },
    runCrawler (website) {
      return api.post(`websites/${website.id}/crawl_sessions`, {
        crawl_session: { status: 'created' }
      }).then((result) => {
        this.isLoading = false
        this.$emit('success', website)
      }).catch((error) => {
        console.error(error)
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
