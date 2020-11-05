import Vue from 'vue'
import router from './router'
import store from './store'

import App from './app'
import PopoverDirective from './misc/directives/popover'
import VueClipboard from 'vue-clipboard2'
import VueContentPlaceholders from 'vue-content-placeholders'

import Button from 'view-design/src/components/button'
import Submenu from 'view-design/src/components/submenu'
import Menu from 'view-design/src/components/menu'
import MenuItem from 'view-design/src/components/menu-item'
import Header from 'view-design/src/components/header'
import Switch from 'view-design/src/components/switch'
import Card from 'view-design/src/components/card'
import Icon from 'view-design/src/components/icon'
import Input from 'view-design/src/components/input'
import Form from 'view-design/src/components/form'
import Radio from 'view-design/src/components/radio'
import Spin from 'view-design/src/components/spin'
import Checkbox from 'view-design/src/components/checkbox'
import Affix from 'view-design/src/components/affix'
import Tag from 'view-design/src/components/tag'
import Divider from 'view-design/src/components/divider'
import Collapse from 'view-design/src/components/collapse'
import Tooltip from 'view-design/src/components/tooltip'
import { Select, Option } from 'view-design/src/components/select'

Vue.use(VueClipboard)
Vue.use(VueContentPlaceholders)

Vue.directive('popover', PopoverDirective)

Vue.component('IButton', Button)
Vue.component('ISwitch', Switch)
Vue.component('Menu', Menu)
Vue.component('Submenu', Submenu)
Vue.component('MenuItem', MenuItem)
Vue.component('Icon', Icon)
Vue.component('Header', Header)
Vue.component('Card', Card)
Vue.component('IInput', Input)
Vue.component('IForm', Form)
Vue.component('FormItem', Form.Item)
Vue.component('Spin', Spin)
Vue.component('Checkbox', Checkbox)
Vue.component('Affix', Affix)
Vue.component('Tag', Tag)
Vue.component('Divider', Divider)
Vue.component('Radio', Radio)
Vue.component('RadioGroup', Radio.Group)
Vue.component('Collapse', Collapse)
Vue.component('Panel', Collapse.Panel)
Vue.component('Tooltip', Tooltip)
Vue.component('ISelect', Select)
Vue.component('IOption', Option)

const app = new Vue({
  router,
  store,
  render: h => h(App)
})

export default app
