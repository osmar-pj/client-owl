<template>
    <div class="surface-section px-4 py-8 md:px-6 lg:px-8">
        <div class="text-700 text-center">
            <div class="text-blue-600 font-bold mb-3"><i class="pi pi-home"></i>&nbsp;SET INICIALES</div>
            <div class="field">
                <div class="surface-section px-4 py-5 md:px-6 lg:px-8">
                    <label for="description" class="block text-900 font-medium mb-2">Valor inicial</label>
                    <InputNumber id="description" type="text" class="w-auto mb-3" mode="decimal" :minFractionDigits="1" v-model="initial" />

                    <label for="icon" class="block text-900 font-medium mb-2">Produccion</label>
                </div>
            </div>
            <Button label="Finalizar" icon="pi pi-paperclip" class="font-bold px-5 py-3 p-button-raised p-button-rounded white-space-nowrap" @click.prevent="setInitials"></Button>
        </div>
    </div>
</template>

<script>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'

export default {
    name: 'Mac',
    setup() {
        const router = useRouter()
        const store = useStore()

        const initial = ref()
        const device = store.state.device
        
        const setInitials = () => {
            store.dispatch('post', { data: { initial: initial.value }, route: `help/device/initial/${device.mac}` })
            router.replace('/')
        }

        return { initial, setInitials }
    }
}
</script>