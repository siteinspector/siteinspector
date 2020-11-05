<template>
  <div>
    <User
      v-for="user in users"
      :key="user.id"
      :user="user"
      class="mb-3"
      :removable="user.email.toLowerCase() !== $store.getters.currentUser.email.toLowerCase()"
      @update="$emit('update')"
    />
    <IButton
      role="addUserBtn"
      size="large"
      long
      type="dashed"
      @click="openAddUserModal"
    >
      <Icon type="md-add" />
      Add User
    </IButton>
  </div>
</template>

<script>
import User from './user'
import UserForm from './form'
import { Modal, Message } from 'ui/misc/scripts/dynamic_components'

export default {
  name: 'UsersList',
  components: {
    User
  },
  props: {
    users: {
      type: Array,
      required: true
    }
  },
  methods: {
    openAddUserModal () {
      Modal.open(UserForm, {
        on: {
          success: (data) => {
            Modal.remove()
            Message.info(`${data.email} user has been added`)

            this.$emit('update')
          }
        }
      }, {
        closable: true
      })
    }
  }
}
</script>
