<template>
  <Card>
    <div class="row">
      <div class="col-10">
        <div class="row">
          <div class="col-lg-6">
            <Icon type="ios-mail" />
            {{ user.email }}
          </div>
          <div class="col-lg-6">
            <template v-if="fullName">
              <Icon type="ios-person" />
              {{ fullName }}
            </template>
          </div>
        </div>
      </div>
      <div class="col-2 d-flex justify-content-end align-items-center">
        <IButton
          v-if="removable"
          type="text"
          @click="deleteUser"
        >
          <Icon
            type="ios-trash"
            class="h1"
          />
        </IButton>
      </div>
    </div>
  </Card>
</template>

<script>
import api from 'ui/api'
import { Dialog, Message } from 'ui/misc/scripts/dynamic_components'

export default {
  name: 'User',
  props: {
    user: {
      type: Object,
      required: true
    },
    removable: {
      type: Boolean,
      required: false,
      default: true
    }
  },
  computed: {
    fullName () {
      return [this.user.first_name, this.user.last_name].filter(e => e).join(' ')
    }
  },
  methods: {
    deleteUser () {
      Dialog.confirm({
        title: 'Are you sure?',
        closable: true,
        onOk: () => {
          api.delete(`users/${this.user.id}`).then(() => {
            Message.info(`${this.user.email} user has been removed`)
            this.$emit('update')
          }).catch((error) => {
            console.error(error)
            this.$Message.error('Unable to perform this action')
          })
        }
      })
    }
  }
}
</script>
