import DynamicComponent from './dynamic_component'
import DrawerComponent from 'view-design/src/components/drawer/drawer.vue'

const defaultOptions = {
  visible: false,
  width: 720,
  closable: false
}

class DynamicDrawer {
  constructor (injections) {
    this.injections = injections || {}
  }

  open (component, props, opts) {
    const options = { ...defaultOptions, ...opts }
    const instance = this.getDrawerInstance(component, props, options)

    instance.show(options)
  }

  remove () {
    if (this.drawerInstance) {
      const instance = this.getDrawerInstance()

      instance.remove()
    }
  }

  getDrawerInstance (component, props, options) {
    this.drawerInstance = this.drawerInstance || new DynamicComponent(
      DrawerComponent,
      this.injections,
      options,
      (h) => h(component, { ...props }),
      () => {
        if (options.onClose) options.onClose()
        this.drawerInstance = null
      }
    )

    return this.drawerInstance
  }
}

export default DynamicDrawer
