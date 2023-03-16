<template>
    <div class="">
        <div class="flex align-items-center justify-content-center h-screen">
            <div class="surface-card p-4 shadow-2 border-round w-full lg:w-6">
                <div class="text-center mb-5">
                    <!-- <img src="images/blocks/logos/hyper.svg" alt="Image" height="50" class="mb-3"> -->
                    <div class="text-900 text-3xl font-medium mb-3">Bienvenido</div>
                    <span class="text-600 font-medium line-height-3">No tienes una cuenta?</span>
                    <router-link class="font-medium no-underline ml-2 text-yellow-500 cursor-pointer" to="/register">Sign Up!</router-link>
                </div>

                <div>
                    <label for="email" class="block text-900 font-medium mb-2">Email</label>
                    <!-- <InputText id="email" type="text" class="w-full mb-3 border-white hover:border-yellow-500 focus:border-yellow-500" v-model="email"/> -->
                    <input type="text" class="text-base text-color surface-overlay p-3 border-1 border-solid surface-border border-round appearance-none outline-none focus:border-yellow-500 w-full mb-3" v-model="email">

                    <label for="password" class="block text-900 font-medium mb-2">Password</label>
                    <!-- <InputText id="password" type="password" class="w-full mb-3 p-text-secondary" v-model="password"/> -->
                    <input type="password" class="text-base text-color surface-overlay p-3 border-1 border-solid surface-border border-round appearance-none outline-none focus:border-yellow-500 w-full mb-3" v-model="password">

                    <div class="flex align-items-center justify-content-between mb-6">
                        <!-- <div class="flex align-items-center">
                            <Checkbox id="rememberme" :binary="true" v-model="checked" class="mr-2"></Checkbox>
                            <label for="rememberme">Recuerdame</label>
                        </div> -->
                        <a class="font-medium no-underline ml-2 text-gray-500 text-right cursor-pointer">Olvidaste tu password?</a>
                    </div>

                    <Button label="Sign In" icon="pi pi-user" class="w-full bg-yellow-500 border-yellow-400" @click="login"></Button>
                    <Message v-if="error" severity="error"> {{ error }} </Message>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'

export default {
    setup() {
        const email = ref('')
        const password = ref('')
        const error = ref(null)

        const store = useStore()
        const router = useRouter()

        const login = async () => {
            error.value = null
            try {
                await store.dispatch('login', { email: email.value, password: password.value })
                router.push('/')
            } catch (err) {
                error.value = err
            }
        }
        return { email, password, login, error }
    }
}
</script>