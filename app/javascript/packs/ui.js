import 'ui/misc/styles/bootstrap'
import 'vue-content-placeholders/src/styles'
import 'ui/index.scss'

import app from 'ui/index'
import store from 'ui/store'

document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('app')) {
    store.dispatch('loadCurrentUser')
    store.dispatch('loadWebsites')

    app.mount('#app')
  }
})
