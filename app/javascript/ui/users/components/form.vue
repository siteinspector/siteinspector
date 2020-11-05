<template>
  <IForm
    ref="form"
    :model="value"
    :rules="rules"
    @keyup.enter.native="handleSubmit"
  >
    <div class="row">
      <FormItem
        prop="first_name"
        label="First Name"
        class="col-12 col-md-6"
      >
        <IInput
          v-model="value.first_name"
          type="text"
          size="large"
          placeholder="John"
        />
      </FormItem>
      <FormItem
        prop="last_name"
        label="Last Name"
        class="col-12 col-md-6"
      >
        <IInput
          v-model="value.last_name"
          type="text"
          size="large"
          placeholder="Doe"
        />
      </FormItem>
      <FormItem
        prop="email"
        label="Email"
        class="col-12"
      >
        <IInput
          v-model="value.email"
          prefix="md-mail"
          type="email"
          name="email"
          size="large"
          placeholder="example@example.com"
        />
      </FormItem>
      <FormItem
        prop="password"
        label="Password"
        class="col-12"
      >
        <IInput
          v-model="value.password"
          prefix="md-key"
          type="password"
          name="password"
          size="large"
          placeholder="**********"
        />
      </FormItem>
    </div>
    <IButton
      type="primary"
      class="mt-1"
      size="large"
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
import { deepCopy } from 'view-design/src/utils/assist'

export default {
  name: 'SetupForm',
  props: {
    user: {
      type: Object,
      required: false,
      default () {
        return {
          email: '',
          password: '',
          first_name: '',
          last_name: ''
        }
      }
    },
    requirePassword: {
      type: Boolean,
      required: false,
      default: true
    },
    mode: {
      type: String,
      required: false,
      default: 'create'
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
      value: {}
    }
  },
  computed: {
    apiPath () {
      return {
        create: 'users',
        setup: 'setup',
        update: `users/${this.user.id}`
      }[this.mode]
    },
    apiMethod () {
      return this.mode === 'update' ? 'put' : 'post'
    },
    rules () {
      return {
        email: [{ required: true, type: 'email' }],
        password: [{ required: this.requirePassword, min: 6 }]
      }
    }
  },
  watch: {
    user (value) {
      if (value) {
        this.value = deepCopy(value)
      }
    }
  },
  mounted () {
    this.value = deepCopy(this.user)
  },
  methods: {
    submit () {
      this.isLoading = true

      api[this.apiMethod](this.apiPath, {
        user: this.value
      }).then((result) => {
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
