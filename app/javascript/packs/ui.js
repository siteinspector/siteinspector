import 'ui/index.less'
import 'ui/index.scss'

import app from 'ui/index'

document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('app')) {
    app.$store.dispatch('loadCurrentUser')
    app.$store.dispatch('loadWebsites')

    app.$mount('#app')
  }
})
