import { createRouter, createWebHistory } from 'vue-router'

import SetupIndex from 'ui/setup/pages/index'
import DashboardIndex from 'ui/dashboard/pages/index'
import ReportsIndex from 'ui/reports/pages/index'
import ReportsShow from 'ui/reports/pages/show'
import ReportsShared from 'ui/reports/pages/shared'
import SettingsIndex from 'ui/settings/pages/index'
import CustomChecksIndex from 'ui/custom_checks/pages/index'

const routes = [
  { path: '/', redirect: '/dashboard' },
  {
    path: '/setup',
    component: SetupIndex,
    name: 'setup'
  },
  {
    path: '/dashboard',
    component: DashboardIndex,
    name: 'dashboard'
  },
  {
    path: '/reports',
    component: ReportsIndex,
    name: 'reports'
  },
  {
    path: '/shared',
    component: ReportsShared,
    name: 'shared'
  },
  {
    path: '/reports/:slug',
    component: ReportsShow,
    name: 'report'
  },
  {
    path: '/settings',
    component: SettingsIndex,
    name: 'settings'
  },
  {
    path: '/custom_checks',
    component: CustomChecksIndex,
    name: 'custom_checks'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
