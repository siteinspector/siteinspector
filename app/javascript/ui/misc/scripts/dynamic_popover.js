import Vue from 'vue'
import Popper from 'popper.js/dist/umd/popper.js'
import Popover from 'ui/misc/components/popover'

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
  show (el, component, options, context) {
    removeCurrentPopover()

    const node = new Vue({
      ...context,
      render (h) {
        return h(Popover, {
          props: {
            bodyStyle: 'padding: 0'
          }
        }, [
          h(component, options)
        ])
      }
    }).$mount()

    document.body.appendChild(node.$el)

    currentPopover = new Popper(el, node.$el, { placement: 'top' })
  },
  remove () {
    removeCurrentPopover()
  }
}
