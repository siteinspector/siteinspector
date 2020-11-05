import Vue from 'vue'
import Popper from 'popper.js/dist/umd/popper.js'
import Popover from '../components/popover'

let currentPopover

function removeCurrentPopover () {
  if (currentPopover) {
    currentPopover.destroy()
    currentPopover.popper.remove()
  }
}

document.addEventListener('click', (e) => {
  if (currentPopover) {
    removeCurrentPopover()
  }
})

export default {
  inserted (el, binding) {
    if (binding.value.disabled) return

    el.addEventListener(binding.value.trigger || 'click', () => {
      removeCurrentPopover()

      const { on, ...attrs } = binding.value

      const node = new Vue({
        render (h) {
          return h(Popover, { props: attrs, on: on })
        }
      }).$mount()

      document.body.appendChild(node.$el)

      currentPopover = new Popper(el, node.$el, { placement: 'top' })
    })
  }
}
