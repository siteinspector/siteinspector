<template>
  <div class="layout">
    <MainHeader v-if="!['setup', 'shared'].includes($route.name)" />
    <div class="container py-3 pb-5">
      <RouterView />
    </div>
  </div>
</template>

<script>
import MainHeader from './navigation/components/header'

export default {
  name: 'App',
  components: {
    MainHeader
  }
}
</script>

<style lang="scss">
.layout {
  position: relative;
  min-height: 100vh;
}
</style>
