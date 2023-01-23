<template>
    <div class="">
        <div class="flex align-items-center justify-content-center h-screen" v-if="user.user == 'Admin'">
            <div class="surface-card p-4 shadow-2 border-round w-full lg:w-6">
                <div class="text-center mb-5">
                    <!-- <img src="images/blocks/logos/hyper.svg" alt="Image" height="50" class="mb-3"> -->
                    <div class="text-900 text-3xl font-medium mb-3">Registrar</div>
                    <!-- <span class="text-600 font-medium line-height-3">Ya tienes una cuenta?</span> -->
                    <!-- <router-link class="font-medium no-underline ml-2 text-blue-500 cursor-pointer" to="/login">Sign In!</router-link> -->
                </div>

                <div>
                    <label for="name" class="block text-900 font-medium mb-2">Nombre</label>
                    <InputText id="name" type="text" class="w-full mb-3" v-model="name" />

                    <label for="lastname" class="block text-900 font-medium mb-2">Apellido</label>
                    <InputText id="lastname" type="text" class="w-full mb-3" v-model="lastname" />

                    <label for="Celular" class="block text-900 font-medium mb-2">Celular</label>
                    <InputText id="celular" type="text" class="w-full mb-3" v-model="celular" />

                    <label for="email" class="block text-900 font-medium mb-2">Email</label>
                    <InputText id="email" type="text" class="w-full mb-3" v-model="email" />

                    <label for="password" class="block text-900 font-medium mb-2">Password</label>
                    <InputText id="password" type="password" class="w-full mb-3" v-model="password" />

                    <Button label="Sign Up" icon="pi pi-user" class="w-full" @click.prevent="register" ></Button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'

export default {
    setup() {
        const store = useStore()
        const router = useRouter()

        onMounted(() => {
            user.value = store.state.user
        })

        const name = ref('')
        const lastname = ref('')
        const celular = ref('')
        const email = ref('')
        const password = ref('')
        const user = ref({})

        const register = async () => {
            try {
                await store.dispatch('register', { name: name.value, lastname: lastname.value, celular: celular.value, email: email.value, password: password.value, roles: ['moderator', 'user'] })
                router.replace('/')
            } catch (error) {
                console.error(error)
            }
        }
        return { name, lastname, email, password, celular, user, register }
    }
}
</script>

<style scoped></style>