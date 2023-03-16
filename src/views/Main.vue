<template>
    <div>
        <div class="surface-hover px-4 py-8 md:px-6 lg:px-8 text-center">
            <div class="mb-3 font-bold text-2xl">
                <span class="text-900">Bienvenido, </span>
                <span class="text-yellow-600">Paranoid Smart Systems</span>
            </div>
            <div class="text-700 text-sm mb-6">Tu casa inteligente en la palma de tu mano.</div>
        <!-- </div>
        <div class="surface-hover"> -->
            <div class="grid border-red-100 border-1 border-round my-2 px-2" v-for="d in devices">
                <!-- <h4> {{ d.place }} </h4> -->
                <div class="col-12 md:col-6 lg:col-3 xl:col-2 my-2 px-2" v-for="(s, i) in d.s">
                    <div class="surface-card shadow-1 p-3 border-round h-12rem flex flex-column justify-content-around">
                        <div class="flex justify-content-between ">
                            <div>
                                <span :class="`block text-500 text-xs ${!notification ? 'text-gray-300' : ''}`"> {{ d.place }} </span>
                            </div>
                            <div>
                                <i :class="`pi pi-circle-fill ${ notification ? 'text-green-500' : 'text-gray-300' } text-sm mr-2`"></i>
                            </div>
                        </div>
                        <div class="">
                            <InputSwitch v-model="s.value" class="" v-if="s.type == 'ad'" @change="publish(d.mac, s, i)" :disabled="!notification"/>
                            <i :class="`pi pi-mobile ${s.value ? 'text-green-500' : 'text-red-500'} text-5xl`" v-if="s.type == 'sd'" ></i>
                            <p v-if="s.type == 'aa'"> <span class="text-3xl font-medium"> {{ (s.value + s.x0).toFixed(1) }} </span> <span> {{ s.unit }} </span> </p>
                            <Slider v-if="s.type == 'aa'" v-model="s.value"  @slideend="publish(d.mac, s)" :disabled="!notification"/>
                            <p v-if="s.type == 'sa'" :class="`${!notification ? 'text-gray-300' : ''}`" > <span class="text-5xl font-semibold"> {{ (s.value + s.x0).toFixed(1) }} </span> <span> {{ s.unit }} </span> </p>
                            <i v-if="((s.value > s.max || s.value < s.min) && s.type == 'sa' )" :class="`pi pi-exclamation-triangle text-yellow-300 animation-duration-500 scalein animation-iteration-infinite`"></i>
                            <!-- <Button v-if="s.type == 'ad'" icon="pi pi-power-off" class="p-button-rounded p-button-outlined p-button-success" /> -->
                        </div>
                        <div class="flex align-items-center justify-content-center mt-2">
                            <i class="pi pi-minus text-blue-500 text-sm mr-2"></i>
                            <span :class="`text-900 font-medium text-md ${!notification ? 'text-gray-300' : ''}`"> {{ s.nm }} </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { ref, inject, onMounted, computed, effect } from 'vue'
import { useStore } from 'vuex'
import { Subject, interval } from 'rxjs'

export default {
    setup() {
        const store = useStore()
        const socket = inject('socket')
        
        const device$ = new Subject()
        
        const devices = ref([])
        const conexion = ref(false)
        let device = {
            mac: '',
            s: [],
            updatedAt: new Date()
        }


        socket.on('deviceData', data => {
            device = devices.value.find(d => d.mac === data.mac)
            device ? updateDevice(device, data) : console.log('no device')
        })

        onMounted(async () => {
            devices.value = await store.dispatch('get', {route: 'device'})
            // console.log(devices.value)
        })

        const updateDevice = (device, data) => {
            device.s = data.s
            device.updatedAt = data.updatedAt
            device$.next(device)
        }

        // computes notificacion variable
        const interval = setInterval(() => {
            conexion.value = (new Date() - new Date(device.updatedAt))/1000 < 10
        }, 1000)

        effect(() => {
            return conexion.value
        })
        const notification = computed(() => {
            return conexion.value
        })

        const publish = (mac, s, i) => {
            store.dispatch('post', {route: `help/device/${mac}`, data: {value: { data: s, index: i }}})
        }

        return { devices, publish, notification }
    }
}
</script>