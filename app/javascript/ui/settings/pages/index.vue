<template>
  <div style="max-width: 650px; margin: 0 auto">
    <h1 id="account">
      Account
    </h1>
    <Card class="my-3">
      <UserForm
        :user="currentUser"
        :require-password="false"
        :mode="'update'"
        :submit-text="'Update'"
        class="account-form"
        @success="onUserUpdate"
      />
    </Card>
    <h1 id="users">
      Users
    </h1>
    <UsersList
      v-if="users.length"
      :users="users"
      class="my-3"
      @update="loadUsers"
    />
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
    <h1 id="subscribe">
      Developer newsletters
    </h1>
    <Card
      class="my-3"
    >
      <SubscribeForm
        :submit-text="'Subscribe'"
        :email="currentUser.email"
        @success="subscribeSuccesMessage"
      />
    </Card>
    <a
      href="/sidekiq/dynamic-queues"
      target="_blank"
      class="mt-3 bg-white ivu-btn ivu-btn-primary ivu-btn-long ivu-btn-large ivu-btn-ghost"
    >
      <Icon type="md-log-in" />
      Enter Sidekiq UI
    </a>
    <IButton
      role="signOutBtn"
      size="large"
      class="mt-3 bg-white"
      icon="ios-log-out"
      long
      type="error"
      ghost
      @click="signOut"
    >
      Sign Out
    </IButton>
  </div>
</template>

<script>
import api from 'ui/api'
import UserForm from 'ui/users/components/form'
import SubscribeForm from 'ui/settings/components/subscribe_form'
import UsersList from 'ui/users/components/list'
import { Message } from 'view3/src/plugins/dynamic-components'

export default {
  name: 'SettingsIndex',
  components: {
    UserForm,
    UsersList,
    SubscribeForm
  },
  data () {
    return {
      users: []
    }
  },
  computed: {
    currentUser () {
      return this.$store.getters.currentUser
    }
  },
  mounted () {
    this.loadUsers()
  },
  methods: {
    signOut () {
      api.delete('session', {}).then((_result) => {
      }).catch((error) => {
        console.error(error)
      }).finally(() => {
        window.location.href = '/'
      })
    },
    subscribeSuccesMessage () {
      Message.info('You have been subscribed successfully')
    },
    loadUsers () {
      return api.get('users', {
      }).then((result) => {
        this.users = result.data.data
      }).catch((error) => {
        console.error(error)
      })
    },
    onUserUpdate (user) {
      this.loadUsers().then(() => {
        this.$store.commit('SET_CURRENT_USER', user)

        Message.success('Changes have been saved')
      })
    }
  }
}
</script>
