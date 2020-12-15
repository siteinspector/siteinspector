<template>
  <Spin>
    <div class="d-flex align-items-center">
      <div class="me-1">
        Scanning
      </div>
      <Icon
        type="ios-loading"
        size="18"
        class="demo-spin-icon-load"
      />
    </div>
  </Spin>
</template>

<style scoped>
.demo-spin-icon-load {
  animation: ani-demo-spin 1s linear infinite;
}

@keyframes ani-demo-spin {
  from { transform: rotate(0deg);}
  50%  { transform: rotate(180deg);}
  to   { transform: rotate(360deg);}
}
</style>
