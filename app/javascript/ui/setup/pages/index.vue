<template>
  <div class="setup-container">
    <div class="text-center">
      <h1 class="py-5">
        SiteInspector Setup 👋
      </h1>
    </div>
    <Card class="mb-2">
      <UserForm
        v-if="step === 'user'"
        :mode="'setup'"
        :submit-text="`Let's go!`"
        @success="onUserSuccess"
      />
      <WebsiteForm
        v-if="step === 'website'"
        :start-crawl="true"
        :submit-text="'Scan website'"
        @success="onWebsiteSuccess"
      />
      <SubscribeForm
        v-if="step === 'subscribe'"
        :email="$store.getters.currentUser.email"
        :submit-text="'Subscribe'"
        @success="onSubscribeSuccess"
      />
    </Card>
    <div class="text-center">
      <a
        v-if="step != 'user'"
        href="#"
        @click.prevent="onSkip"
      >
        Skip this step
      </a>
    </div>
    <div
      class="footer text-right"
    >
      <small>
        <a
          href="https://www.getsiteinspector.com/"
          target="_blank"
        > SiteInspector v{{ version }} </a>
      </small>
    </div>
  </div>
</template>

<script>
import UserForm from 'ui/users/components/form'
import WebsiteForm from 'ui/websites/components/form'
import SubscribeForm from 'ui/settings/components/subscribe_form'

export default {
  name: 'SetupIndex',
  components: {
    UserForm,
    WebsiteForm,
    SubscribeForm
  },
  data () {
    return {
      step: 'user'
    }
  },
  computed: {
    version () {
      return process.env.VERSION
    }
  },
  methods: {
    onUserSuccess (user) {
      this.step = 'website'

      this.$store.commit('SET_CURRENT_USER', user)
    },
    onWebsiteSuccess (website) {
      this.step = 'subscribe'

      this.$store.commit('ADD_WEBSITE', website)
    },
    onSubscribeSuccess () {
      this.$router.push({ name: 'dashboard' })
    },
    onSkip () {
      if (this.step === 'website') {
        this.step = 'subscribe'
      } else {
        this.$router.push({ name: 'dashboard' })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.setup-container {
  margin: 0 auto;
  max-width: 650px;
}

.footer {
  position: absolute;
  bottom: 0;
  right: 25px;
  height: 2.5rem;
}
</style>
