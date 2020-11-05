import Vue from 'vue'

class DynamicComponent {
  constructor (component, injections, props, render, onRemove) {
    this.instance = new Vue({
      ...injections,
      data: Object.assign({}, props),
      methods: {
        remove () {
          setTimeout(() => {
            this.destroy()
          }, 300)
        },
        destroy () {
          this.$destroy()
          document.body.removeChild(this.$el)
          onRemove()
        }
      },
      render (h) {
        const { on, ...attrs } = props

        return h(component, {
          props: attrs,
          on: {
            ...on,
            'on-visible-change': (visible) => {
              if (!visible) this.remove()
            }
          }
        }, [
          render(h)
        ])
      }
    })

    document.body.appendChild(this.instance.$mount().$el)
    this.component = this.instance.$children[0]
  }

  show () {
    this.component.visible = true
  }

  remove () {
    this.component.visible = false
  }
}

export default DynamicComponent
