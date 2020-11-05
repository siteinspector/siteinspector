import router from 'ui/router'
import store from 'ui/store'

import Dialog from 'view-design/src/components/modal'
import Message from 'view-design/src/components/message'
import DynamicModal from './dynamic_modal'
import DynamicDrawer from './dynamic_drawer'

const Modal = new DynamicModal({ router, store })
const Drawer = new DynamicDrawer({ router, store })

export { Dialog, Drawer, Modal, Message }
