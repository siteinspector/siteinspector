import 'ui/misc/styles/bootstrap.scss'
import 'vue-content-placeholders/src/styles.scss'
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
