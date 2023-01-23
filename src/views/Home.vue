<template>
    <Menubar :model="items">
        <template #start>
            <router-link to="/">OWL</router-link>
        </template>
        <template #end>
            <Avatar icon="pi pi-user" class="mr-2" shape="circle"/>
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
                label: 'Users',
                icon: 'pi pi-fw pi-user',
                items: [
                    {
                        label: 'New',
                        icon: 'pi pi-fw pi-user-plus',
                    },
                    {
                        label: 'Delete',
                        icon: 'pi pi-fw pi-user-minus',
                    },
                    {
                        label: 'Search',
                        icon: 'pi pi-fw pi-users',
                        items: [
                            {
                                label: 'Filter',
                                icon: 'pi pi-fw pi-filter',
                                items: [
                                    {
                                        label: 'Print',
                                        icon: 'pi pi-fw pi-print'
                                    }
                                ]
                            },
                            {
                                icon: 'pi pi-fw pi-bars',
                                label: 'List'
                            }
                        ]
                    }
                ]
            },
            {
                label: 'Devices',
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
                label: 'Parameters',
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
                label: 'Config',
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
                ]
            },
            {
                label: 'Registrar',
                icon: 'pi pi-fw pi-sign-up',
                command: () => {
                    router.push('/register')
                }
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

        return { items}
    }
}
</script>