<template>
  <div class="layout">
    <Header v-if="!['setup', 'shared'].includes($route.name)" />
    <div class="container py-3 pb-5">
      <RouterView />
    </div>
  </div>
</template>

<script>
import Header from './navigation/components/header'

export default {
  name: 'App',
  components: {
    Header
  }
}
</script>

<style lang="scss">
.layout {
  position: relative;
  min-height: 100vh;
}
</style>
