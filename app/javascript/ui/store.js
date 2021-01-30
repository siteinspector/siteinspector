import Vuex from 'vuex'

const store = new Vuex.Store({
  state: {
    currentUser: {
      email: ''
    },
    websites: []
  },
  actions: {
    loadCurrentUser (store) {
      const node = document.querySelector('[data-user]')
      const params = node && JSON.parse(node.getAttribute('data-user'))

      store.commit('SET_CURRENT_USER', params)
    },
    loadWebsites (store) {
      const node = document.querySelector('[data-websites]')
      const params = node && JSON.parse(node.getAttribute('data-websites'))

      store.commit('SET_WEBSITES', params)
    }
  },
  mutations: {
    SET_CURRENT_USER (state, user) {
      state.currentUser = user
    },
    SET_WEBSITES (state, websites) {
      state.websites = websites
    },
    UPDATE_WEBSITE (state, website) {
      const index = state.websites.findIndex((ws) => ws.id === website.id)

      state.websites.splice(index, 1, website)
    },
    REMOVE_WEBSITE (state, website) {
      const index = state.websites.findIndex((ws) => ws.id === website.id)

      state.websites.splice(index, 1)
    },
    ADD_WEBSITE (state, website) {
      state.websites.push(website)
    }
  },
  getters: {
    currentUser: state => state.currentUser,
    canEdit: state => state.currentUser.role === 'editor',
    websites: state => state.websites
  }
})

export default store
