<template>
  <IForm
    v-if="!isSubmitted && !submittedEmail"
    ref="form"
    :model="value"
    :rules="rules"
    @keyup.enter.native="handleSubmit"
  >
    <div class="row">
      <div class="col-12 mb-3 text-center">
        Subscribe to receive newsletters with feature updates and new version releases
      </div>
      <FormItem
        prop="email"
        class="col-12"
      >
        <IInput
          v-model="value.email"
          prefix="md-mail"
          type="email"
          name="email"
          :disabled="isSubmitted"
          size="large"
          placeholder="example@example.com"
        />
      </FormItem>
    </div>
    <IButton
      type="primary"
      class="mt-1"
      size="large"
      long
      @click="handleSubmit"
    >
      {{ submitText }}
    </IButton>
    <Spin
      v-if="isLoading"
      size="large"
      fix
    />
  </IForm>
  <div v-else>
    <Icon
      type="md-checkmark-circle text-success"
    />
    {{ submittedEmail ? `${submittedEmail} has` : 'You have' }} been subscribed for newsletters
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'SetupForm',
  props: {
    email: {
      type: String,
      required: false,
      default: ''
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
      isSubmitted: false,
      value: { email: '' }
    }
  },
  computed: {
    rules () {
      return {
        email: [{ required: true, type: 'email' }]
      }
    },
    submittedEmail () {
      if (window.localStorage) {
        return JSON.parse(window.localStorage.getItem('newsletter') || '{}').email
      } else {
        return ''
      }
    }
  },
  watch: {
    email (value) {
      if (value) {
        this.value.email = value
      }
    }
  },
  mounted () {
    this.value.email = this.email
  },
  methods: {
    submit () {
      this.isLoading = true

      axios.post('https://getsiteinspector.herokuapp.com/api/subscribers', {
        email: this.value.email
      }).then((result) => {
        window.localStorage.setItem('newsletter', JSON.stringify(result.data))

        this.$emit('success', result.data.data)
      }).catch((error) => {
        console.error(error)
        this.$emit('error', error)
      }).finally(() => {
        this.isSubmitted = true
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
