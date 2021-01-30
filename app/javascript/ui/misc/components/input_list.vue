<template>
  <div>
    <FormItem
      v-for="(item, index) in items"
      :key="index"
    >
      <div class="row">
        <div class="col d-flex">
          <IInput
            v-model="item.value"
            type="text"
            :placeholder="placeholder"
            @input="updateValues"
          />
          <IButton
            class="ms-2"
            icon="md-trash"
            @click="handleRemove(index)"
          />
        </div>
      </div>
    </FormItem>
    <FormItem>
      <div class="row">
        <div class="col">
          <IButton
            type="dashed"
            long
            icon="md-add"
            @click="handleAdd"
          >
            {{ addText }}
          </IButton>
        </div>
      </div>
    </FormItem>
  </div>
</template>

<script>
export default {
  name: 'InputList',
  props: {
    modelValue: {
      type: Array,
      required: true
    },
    addText: {
      type: String,
      required: false,
      default: 'Add'
    },
    placeholder: {
      type: String,
      required: false,
      default: 'Enter value'
    }
  },
  data () {
    return {
      items: []
    }
  },
  mounted () {
    this.assignsItems()
  },
  methods: {
    assignsItems () {
      this.items = this.modelValue.map((item, index) => {
        return {
          value: item,
          index: index
        }
      })
    },
    updateValues () {
      const value = this.items.map((item) => item.value).filter(value => value)

      this.$emit('update:modelValue', value)
    },
    handleRemove (index) {
      this.items.splice(index, 1)
      this.updateValues()
    },
    handleAdd () {
      this.items.push({ value: '', index: this.items.length + 1 })
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
