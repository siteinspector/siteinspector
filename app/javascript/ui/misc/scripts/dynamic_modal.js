import DynamicComponent from './dynamic_component'
import ModalComponent from 'view-design/src/components/modal/modal.vue'

const defaultOptions = {
  visible: false,
  width: 620,
  closable: false,
  footerHide: true
}

class DynamicModal {
  constructor (injections) {
    this.injections = injections || {}
  }

  open (component, props, opts) {
    const options = { ...defaultOptions, ...opts }
    const instance = this.getModalInstance(component, props, options)

    instance.show(options)
  }

  remove () {
    if (this.modalInstance) {
      const instance = this.getModalInstance()

      instance.remove()
    }
  }

  getModalInstance (component, props, options) {
    this.modalInstance = this.modalInstance || new DynamicComponent(
      ModalComponent,
      this.injections,
      options,
      (h) => h(component, { ...props }),
      () => {
        if (options.onClose) options.onClose()
        this.modalInstance = null
      }
    )

    return this.modalInstance
  }
}

export default DynamicModal
