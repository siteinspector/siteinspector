<template>
  <Header>
    <Menu
      mode="horizontal"
      :active-name="activeRoute"
      @on-select="onSelect"
    >
      <div class="container">
        <div class="row">
          <div
            class="d-none d-lg-block col-lg-3 pe-0"
            style="max-height: 0px"
          >
            <span class="h2">
              SiteInspector
            </span>
            <a
              href="https://www.getsiteinspector.com/"
              target="_blank"
              style="font-size: 12px"
            > v{{ version }} </a>
          </div>
          <div
            class="col-10 col-lg-6 d-flex justify-content-lg-center"
          >
            <MenuItem
              name="dashboard"
              :to="{ name: 'dashboard' }"
            >
              <span class="item-text">Dashboard</span>
            </MenuItem>
            <MenuItem
              name="reports"
              :to="{ name: 'reports' }"
            >
              <span class="item-text">Report</span>
            </MenuItem>
            <MenuItem
              name="custom_checks"
              :to="{ name: 'custom_checks' }"
            >
              <span class="item-text">Custom <span class="d-none d-lg-inline">checks</span></span>
            </MenuItem>
          </div>
          <div
            class="col-2 col-lg-3 justify-content-end d-flex"
          >
            <Submenu
              name="add"
            >
              <MenuItem name="add_website">
                <Icon type="md-browsers" />
                Add Website
              </MenuItem>
              <MenuItem name="add_rule">
                <Icon type="md-compass" />
                Add Rule
              </MenuItem>
              <MenuItem name="add_user">
                <Icon type="ios-person-add" />
                Add User
              </MenuItem>
            </Submenu>
            <MenuItem
              name="settings"
              :to="{ name: 'settings' }"
            >
              <h3>
                <Icon type="ios-settings" />
              </h3>
            </MenuItem>
          </div>
        </div>
      </div>
    </Menu>
  </Header>
</template>

<script>
import WebsiteForm from 'ui/websites/components/form'
import UserForm from 'ui/users/components/form'
import { Dialog, Modal } from 'ui/misc/scripts/dynamic_components'
import VERSION from 'ui/version'

export default {
  name: 'MainHeader',
  components: {
  },
  computed: {
    version () {
      return VERSION
    },
    activeRoute () {
      if (this.$route.matched[0]?.name === 'report') {
        return 'reports'
      }

      return this.$route.matched[0]?.name
    }
  },
  methods: {
    onSelect (itemName) {
      if (itemName === 'add_website') {
        if (this.$route.name === 'dashboard') {
          document.querySelector('[role="addWebsiteBtn"]').click()
        } else {
          this.openAddWebsiteModal()
        }
      } else if (itemName === 'add_rule') {
        if (this.$route.name === 'custom_checks') {
          document.querySelector('[role="addCustomRuleBtn"]').click()
        } else {
          this.$router.push({ name: 'custom_checks' })
        }
      } else if (itemName === 'add_user') {
        if (this.$route.name === 'settings') {
          document.querySelector('[role="addUserBtn"]').click()
        } else {
          this.openAddUserModal()
        }
      }
    },
    openAddWebsiteModal () {
      Modal.open(WebsiteForm, {
        on: {
          success: () => {
            this.$router.push({ name: 'dashboard' })
            Modal.remove()
          }
        }
      }, {
        title: 'Add website',
        closable: true
      })
    },
    openAddUserModal () {
      Modal.open(UserForm, {
        on: {
          success: (data) => {
            Dialog.info(`${data.email} user has been added`)
            Modal.remove()
          }
        }
      }, {
        title: 'Add user',
        closable: true
      })
    }
  }
}
</script>

<style lang="sass">
@import 'ui/misc/styles/breakpoints';

.ivu-layout-header {
  .ivu-menu-item {
    font-size: 17px;
    display: flex;
    align-items: center;
  }

  .ivu-icon.ivu-menu-submenu-title-icon:before {
    content: "\f330" !important;
    font-size: 20px;
  }

  @media (max-width: $breakpoint-sm) {
    .ivu-menu-item {
      font-size: 16px;
    }

    .ivu-icon.ivu-menu-submenu-title-icon:before {
      font-size: 16px;
    }

    .ivu-menu-horizontal .ivu-menu-item, .ivu-menu-horizontal .ivu-menu-submenu {
      padding: 0 10px;
    }
  }
}
</style>
