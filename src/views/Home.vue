<template>
    <Menubar :model="items">
        <template #start>
            <router-link to="/">
                <img class="w-9rem" src="../assets/isologo.svg" alt="">
            </router-link>
        </template>
        <template #end>
            <div class="flex align-items-center">
                <h4 class="mr-3 text-gray-500"> {{  store.state.user.user  }} </h4>
                <Avatar icon="pi pi-user text-orange-500" class="mr-2" shape="circle"/>
            </div>
        </template>
    </Menubar>
    <div>
        <router-view></router-view>
    </div>
</template>

<script>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'

export default {
    setup() {
        const router = useRouter()
        const store = useStore()

        const items = ref([
            {
                label: 'Usuarios',
                icon: 'pi pi-fw pi-user',
                command: () => {
                    router.push('/users')
                }
            },
            {
                label: 'Dispositivos',
                icon: 'pi pi-fw pi-file',
                items: [
                    {
                        label: 'Nuevo',
                        icon: 'pi pi-fw pi-plus',
                        command: () => {
                            router.push('/devices/new')
                        }
                    },
                    {
                        label: 'Registrados',
                        icon: 'pi pi-fw pi-list',
                        command: () => {
                            router.push('/devices')
                        }
                    }
                    // {label: 'Delete', icon: 'pi pi-fw pi-trash'},
                    // {separator: true},
                    // {label: 'Export', icon: 'pi pi-fw pi-external-link'}
                ]
            },
            {
                label: 'Parametros',
                icon: 'pi pi-fw pi-database',
                items: [
                    {
                        label: 'Nuevo',
                        icon: 'pi pi-fw pi-plus',
                        command: () => {
                            router.push('/parameters/new')
                        }
                    },
                    {
                        label: 'Registrados',
                        icon: 'pi pi-fw pi-list',
                        command: () => {
                            router.push('/parameters')
                        }
                    }
                ]
            },
            {
                label: 'Configuración',
                icon: 'pi pi-fw pi-pencil',
                items:[
                    {
                        label: 'Mac',
                        icon: 'pi pi-fw pi-search',
                        command: () => {
                            router.push('/config/mac')
                        }
                    },
                    {
                        label: 'Tengo la MAC',
                        icon: 'pi pi-fw pi-pencil',
                        command: () => {
                            router.push('/config/set/mac')
                        }
                    }
                ],
                // visible: store.state.user.user === "Admin"
            },
            {
                label: 'Registro',
                icon: 'pi pi-fw pi-sign-up',
                command: () => {
                    router.push('/register')
                },
                visible: store.state.user.user === "Admin"
            },
            {
                label: 'Salir',
                icon: 'pi pi-fw pi-sign-out',
                command: () => {
                    store.dispatch('logout')
                    router.push('/login')
                }
            }
        ])

        return { items, store }
    }
}
</script>