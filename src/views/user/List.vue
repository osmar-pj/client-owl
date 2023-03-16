<template>
    <div>
        <div class="card">
            <Toolbar class="mb-4">
                <template #start>
                    <Button label="New" icon="pi pi-plus" class="p-button-success mr-2" @click="openNew" />
                    <!-- <Button label="Delete" icon="pi pi-trash" class="p-button-danger" @click="confirmDeleteSelected" :disabled="!selectedProducts || !selectedProducts.length" /> -->
                </template>

                <template #end>
                    <FileUpload mode="basic" accept="image/*" :maxFileSize="1000000" label="Import" chooseLabel="Import" class="mr-2 inline-block" />
                    <Button label="Export" icon="pi pi-upload" class="p-button-help" @click="exportCSV($event)"  />
                </template>
            </Toolbar>

            <DataTable ref="dt" :value="users" v-model:selection="selectedProducts" dataKey="id" 
                :paginator="true" :rows="10" :filters="filters"
                paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown" :rowsPerPageOptions="[5,10,25]"
                currentPageReportTemplate="Showing {first} to {last} of {totalRecords} products" responsiveLayout="scroll">
                <template #header>
                    <div class="table-header flex flex-column md:flex-row md:justiify-content-between">
						<h5 class="mb-2 md:m-0 p-as-md-center">Adminitracion de usuarios</h5>
						<span class="p-input-icon-left">
                            <i class="pi pi-search" />
                            <InputText v-model="filters['global'].value" placeholder="Buscar..." />
                        </span>
					</div>
                </template>

                <Column field="_id" header="Code" :sortable="true" style="min-width:6rem">
                    <template #body="slotProps">
                        {{ slotProps.data._id.substring(slotProps.data._id.length - 6) }}
                    </template>
                </Column>
                
                <Column field="nombre" header="Nombres" :sortable="true" style="min-width:8rem">
                    <template #body="slotProps">
                        {{ slotProps.data.name }}
                    </template>
                </Column>
                <Column field="apellido" header="Apellidos" :sortable="true" style="min-width:6rem">
                    <template #body="slotProps">
                        {{ slotProps.data.lastname }}
                    </template>
                </Column>
                <Column field="celular" header="Movil" :sortable="true" style="min-width:6rem">
                    <template #body="slotProps">
                        {{ slotProps.data.mobile }}
                    </template>
                </Column>
                <Column field="email" header="Correo" :sortable="true" style="min-width:6rem">
                    <template #body="slotProps">
                        {{ slotProps.data.email }}
                    </template>
                </Column>
                <Column field="valid" header="Activado" :sortable="true" style="min-width:6rem">
                    <template #body="slotProps">
                        <i :class="`pi pi-${slotProps.data.valid ? 'check text-green-600' : 'times text-red-600'}` "></i>
                    </template>
                </Column>
                <Column field="fecha" header="Activado" :sortable="true" style="min-width:6rem">
                    <template #body="slotProps">
                        {{ new Date(slotProps.data.updatedAt) }}
                    </template>
                </Column>
                <Column field="roles" header="Roles" :sortable="true" style="min-width:10rem">
                    <template #body="slotProps">
                        <div class="flex align-items-center flex-column sm:flex-row" v-for="p in slotProps.data.roles">
                            <Chip :label="p.name" :class="`mr-2 mb-2 text-xs text-white ${p.name == 'moderator' ? 'bg-yellow-400' : p.name == 'user' ? 'bg-red-400' : 'bg-teal-400'}`" />
                        </div>
                    </template>
                </Column>
                <Column :exportable="false" style="min-width:8rem">
                    <template #body="slotProps">
                        <Button icon="pi pi-pencil" class="p-button-rounded p-button-success mr-2" @click="editUser(slotProps.data)" />
                        <Button icon="pi pi-trash" class="p-button-rounded p-button-warning" @click="confirmDeleteUser(slotProps.data)" />
                    </template>
                </Column>
            </DataTable>
        </div>

        <Dialog v-model:visible="userDialog" :style="{width: '450px'}" header="Detalles de usuario" :modal="true" class="p-fluid">
            <div class="surface-section saveUserx-4 py-5 md:px-6 lg:px-8">
                <label for="name" class="block text-900 font-medium mb-2">Nombre</label>
                <InputText id="name" type="text" class="w-full mb-3" v-model="name" />

                <label for="lastname" class="block text-900 font-medium mb-2">Apellidos</label>
                <InputText id="lastname" type="text" class="w-full mb-3" v-model="lastname" />

                <label for="mobile" class="block text-900 font-medium mb-2">Celular</label>
                <InputText id="mobile" type="text" class="w-full mb-3" v-model="mobile" />

                <label for="email" class="block text-900 font-medium mb-2">Correo</label>
                <InputText id="email" type="text" class="w-full mb-3" v-model="email" />

                <label for="valid" class="block text-900 font-medium mb-2">Valid</label>
                <Checkbox name="" value="" v-model="valid" class="mb-3" :binary="true"/>

                <label for="roles" class="block text-900 font-medium mb-2">Roles</label>
                <div v-for="role of roles" :key="role._id" class="flex align-items-center">
                    <Checkbox :inputId="role._id" name="role" :value="role.name" v-model="selectedRoles" class="mb-3"/>
                    <label :for="role._id" class="ml-2 mb-3"> {{ role.name }} </label>
                </div>

            </div>

            <template #footer>
                <Button label="Cancel" icon="pi pi-times" class="p-button-text" @click="hideDialog"/>
                <Button label="Save" icon="pi pi-check" class="p-button-text" @click="saveUser" />
            </template>
        </Dialog>

        <Dialog v-model:visible="deleteUserDialog" :style="{width: '450px'}" header="Confirm" :modal="true">
            <div class="confirmation-content">
                <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
                <span v-if="product">Estas seguro de querer eliminar<b>{{product.name}}</b>?</span>
            </div>
            <template #footer>
                <Button label="No" icon="pi pi-times" class="p-button-text" @click="deleteUserDialog = false"/>
                <Button label="Yes" icon="pi pi-check" class="p-button-text" @click="deleteUser" />
            </template>
        </Dialog>

        <Dialog v-model:visible="deleteUsersDialog" :style="{width: '450px'}" header="Confirm" :modal="true">
            <div class="confirmation-content">
                <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
                <span v-if="product">Are you sure you want to delete the selected products?</span>
            </div>
            <template #footer>
                <Button label="No" icon="pi pi-times" class="p-button-text" @click="deleteUsersDialog = false"/>
                <Button label="Yes" icon="pi pi-check" class="p-button-text" @click="deleteSelectedProducts" />
            </template>
        </Dialog>
        <Toast/>
	</div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { FilterMatchMode } from 'primevue/api'
import { useToast } from 'primevue/usetoast'
import { useStore } from 'vuex'
import { useRoute } from 'vue-router'

export default {
    setup() {
        const store = useStore()
        const route = useRoute()
        onMounted(async () => {
            await initial()
        })

        const initial = async () => {
            const data = await store.dispatch('get', { route: 'user' })
            users.value = data.usersFiltered2
            roles.value = data.rolesFiltered
        }

        const users = ref([])
        const id = ref()
        const name = ref()
        const lastname = ref()
        const email = ref()
        const mobile = ref()
        const valid = ref(false)
        const roles = ref([])
        const selectedRoles = ref([])
        
        const dt = ref()
        const toast = useToast()
        const userDialog = ref(false)
        const deleteUserDialog = ref(false)
        const deleteUsersDialog = ref(false)
        const selectedProducts = ref()

        const filters = ref({
            'global': {value: null, matchMode: FilterMatchMode.CONTAINS}
        })

        const submitted = ref(false)
        const openNew = () => {
            id.value = null
            name.value = null
            lastname.value = null
            email.value = null
            mobile.value = null
            valid.value = null
            submitted.value = false
            userDialog.value = true
        }
        const editUser = (p) => {
            console.log(p)
            id.value = p._id
            name.value = p.name
            lastname.value = p.lastname
            email.value = p.email
            mobile.value = p.mobile
            valid.value = p.valid
            selectedRoles.value = p.roles.map(i => i.name)
            userDialog.value = true;
        }
        const hideDialog = () => {
            id.value = null
            name.value = null
            lastname.value = null
            email.value = null
            mobile.value = null
            valid.value = null
            userDialog.value = false
        }
        const confirmDeleteUser = (p) => {
            id.value = p._id
            deleteUserDialog.value = true;
        }
        
        const saveUser = async () => {
            submitted.value = true
            if (!id.value) {
                await store.dispatch('post', { data: {name: name.value, lastname: lastname.value, email: email.value, mobile: mobile.value, valid: valid.value, roles: selectedRoles.value}, route: 'user' })
                toast.add({severity:'success', summary: 'User creado', detail:'Se registro el nuevo user', life: 3000})
            } else {
                await store.dispatch('putId', { data: {name: name.value, lastname: lastname.value, email: email.value, mobile: mobile.value, valid: valid.value, roles: selectedRoles.value}, route: 'user', id: id.value})
                toast.add({severity:'success', summary: 'User actualizado', detail:'Se actualizo el user', life: 3000})
            }
            userDialog.value = false
            await initial()
        }

        const deleteUser = async () => {
            await store.dispatch('deleteId', { route: 'user', id: id.value })
            deleteUserDialog.value = false;
            toast.add({severity:'warn', summary: 'Usuario eliminado', detail:'Se elimino el usuario de la BD', life: 3000});
            await initial()
        }

        const findIndexById = (id) => {
            let index = -1
            for (let i = 0; i < products.value.length; i++) {
                if (products.value[i].id === id) {
                    index = i
                    break
                }
            }

            return index
        }

        const createId = () => {
            let id = '';
            var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
            for ( var i = 0; i < 5; i++ ) {
                id += chars.charAt(Math.floor(Math.random() * chars.length))
            }
            return id
        }

        const exportCSV = () => {
            dt.value.exportCSV()
        }

        return { users, name, lastname, email, mobile, valid, roles, dt, userDialog, deleteUserDialog, deleteUsersDialog,
            selectedProducts, filters, submitted, openNew, hideDialog, saveUser, editUser, confirmDeleteUser, deleteUser, 
            findIndexById, createId, exportCSV, selectedRoles}
    }
}
</script>
4
<style lang="scss" scoped>
.table-header {
    display: flex;
    align-items: center;
    justify-content: space-between;

    @media screen and (max-width: 960px) {
        align-items: start;
	}
}

.product-image {
    width: 50px;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
}

.p-dialog .product-image {
    width: 50px;
    margin: 0 auto 2rem auto;
    display: block;
}

.confirmation-content {
    display: flex;
    align-items: center;
    justify-content: center;
}
@media screen and (max-width: 960px) {
	::v-deep(.p-toolbar) {
		flex-wrap: wrap;
        
		.p-button {
            margin-bottom: 0.25rem;
        }
	}
}
// .p-chip.custom-chip {
//     background: var(--green-400);
//     color: var(--primary-color-text);
// }
</style>