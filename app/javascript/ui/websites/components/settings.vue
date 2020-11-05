<template>
  <div v-if="!isSpin">
    <IForm
      ref="settingsForm"
      :model="preferences"
    >
      <Divider>Exclude words</Divider>
      <InputList
        v-model="preferences.exclude_words"
        :placeholder="'word'"
      />
      <Divider>Exclude paths</Divider>
      <InputList
        v-model="preferences.exclude_paths"
        :placeholder="'/path*'"
      />
      <Divider>Include paths</Divider>
      <InputList
        v-model="preferences.include_paths"
        :placeholder="'/path*'"
      />
      <Divider />
      <FormItem label="Start from path">
        <IInput
          v-model="preferences.start_path"
          name="start_path"
        />
      </FormItem>
      <FormItem label="Exclude xpath selector">
        <IInput v-model="preferences.exclude_xpath" />
      </FormItem>
      <Divider>Website checks</Divider>
      <div class="row">
        <div class="col-6 ivu-form-item">
          <ISwitch
            v-model="preferences.check_spelling_and_grammar"
            size="large"
          >
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </ISwitch>
          <label>Spelling and grammar</label>
        </div>
        <div class="col-6 ivu-form-item">
          <ISwitch
            v-model="preferences.check_links"
            size="large"
          >
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </ISwitch>
          <label>Links</label>
        </div>
        <div class="col-6 ivu-form-item">
          <ISwitch
            v-model="preferences.check_images"
            size="large"
          >
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </ISwitch>
          <label>Images</label>
        </div>
        <div class="col-6 ivu-form-item">
          <ISwitch
            v-model="preferences.check_scripts"
            size="large"
          >
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </ISwitch>
          <label>Scripts</label>
        </div>
      </div>
    </IForm>
    <div class="drawer-footer">
      <IButton
        style="float: left"
        type="error"
        :loading="isRemoveLoading"
        ghost
        @click="removeWebsite"
      >
        Remove Website
      </IButton>
      <IButton
        style="margin-right: 8px"
        @click="$emit('close')"
      >
        Cancel
      </IButton>
      <IButton
        type="primary"
        :loading="isOkLoading"
        @click="submit"
      >
        Submit
      </IButton>
    </div>
  </div>
  <Spin
    v-else
    size="large"
    fix
  />
</template>

<script>
import api from 'ui/api'
import InputList from 'ui/misc/components/input_list'
import { Dialog, Message } from 'ui/misc/scripts/dynamic_components'

export default {
  name: 'WebsiteSettings',
  components: {
    InputList
  },
  props: {
    website: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      preferences: {},
      isOkLoading: false,
      isRemoveLoading: false,
      isSpin: true
    }
  },
  mounted () {
    this.loadPreferences()
  },
  methods: {
    loadPreferences () {
      return api.get(`websites/${this.website.id}`, {
        fields: {
          website: 'preferences'
        }
      }).then((result) => {
        this.preferences = result.data.data.preferences
      }).catch(error => {
        console.error(error)
      }).finally(() => {
        this.isSpin = false
      })
    },
    removeWebsite () {
      Dialog.confirm({
        title: 'Are you sure?',
        closable: true,
        onOk: () => {
          this.isRemoveLoading = true

          api.delete(`websites/${this.website.id}`, {
          }).then((result) => {
            Message.info(`${this.website.domain} website has been removed`)

            this.$store.commit('REMOVE_WEBSITE', this.website)

            this.$emit('close')
          }).catch(error => {
            console.error(error)
          })
        }
      })
    },
    submit () {
      this.isOkLoading = true

      api.put(`websites/${this.website.id}`, {
        website: {
          preferences: this.preferences
        }
      }).then((result) => {
        this.$emit('success', this.preferences)
      }).catch(error => {
        console.error(error)
      })
    }
  }
}
</script>

<style lang="scss" scoped>
/deep/

form {
  min-height: 85vh;
}

.drawer-footer {
  width: 100%;
  position: sticky;
  bottom: 0;
  left: 0;
  border-top: 1px solid #e8e8e8;
  padding: 10px 0px;
  text-align: right;
  background: #fff;
}

.ivu-form-item {
  .ivu-form-item-label {
    order: 2;
  }
}
</style>
