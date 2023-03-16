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

            <DataTable ref="dt" :value="devices" v-model:selection="selectedProducts" dataKey="id" 
                :paginator="true" :rows="10" :filters="filters"
                paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown" :rowsPerPageOptions="[5,10,25]"
                currentPageReportTemplate="Showing {first} to {last} of {totalRecords} products" responsiveLayout="scroll">
                <template #header>
                    <div class="table-header flex flex-column md:flex-row md:justiify-content-between">
						<h5 class="mb-2 md:m-0 p-as-md-center">Adminitracion de dispositivos</h5>
						<span class="p-input-icon-left">
                            <i class="pi pi-search" />
                            <InputText v-model="filters['global'].value" placeholder="Buscar..." />
                        </span>
					</div>
                </template>
                <Column field="_id" header="Code" :sortable="true" style="min-width:6rem">
                    <template #body="slotProps">
                        <!-- get last 6 string of a character -->
                        {{ slotProps.data._id.substring(slotProps.data._id.length - 4) }}
                    </template>
                </Column>
                <Column field="mac" header="Mac" :sortable="true" style="min-width:8rem">
                    <template #body="slotProps">
                        {{ slotProps.data.mac }}
                    </template>
                </Column>
                <Column field="place" header="Lugar" :sortable="true" style="min-width:6rem">
                    <template #body="slotProps">
                        {{ slotProps.data.place }} 
                    </template>
                </Column>
                <Column field="fixed" header="Parametros" :sortable="true" style="min-width:10rem">
                    <template #body="slotProps">
                        <div class="flex align-items-center flex-column sm:flex-row" v-for="p in slotProps.data.s">
                            <Chip :label="p.nm" class="mr-2 mb-2 custom-chip text-xs" />
                        </div>
                    </template>
                </Column>
                <Column :exportable="false" style="min-width:8rem">
                    <template #body="slotProps">
                        <Button icon="pi pi-pencil" class="p-button-rounded p-button-success mr-2" @click="editDevice(slotProps.data)" />
                        <Button icon="pi pi-trash" class="p-button-rounded p-button-warning" @click="confirmDeleteDevice(slotProps.data)" />
                    </template>
                </Column>
            </DataTable>
        </div>

        <Dialog v-model:visible="deviceDialog" :style="{width: '450px'}" header="Detalles de parametro" :modal="true" class="p-fluid">
            <div class="surface-section px-4 py-5 md:px-6 lg:px-8">
                <h3 class="text-blue-500"> {{ mac }} </h3>
                <label for="place" class="block text-900 font-medium mb-2">Lugar</label>
                <InputText id="place" type="text" class="w-full mb-3" v-model="place" />
                <label for="parametros" class="block text-900 font-medium mb-2">Parametros</label>
                <DataTable :value="s" datakey="id" responsiveLayout="scroll">
                    <Column field="nm"> </Column>
                    <Column>
                        <template #body="slotProps">
                            <Button class="p-button p-component p-button-text p-button-icon-only p-button-icon-left" @click="selectedParameter(slotProps)">
                                <span class="p-button-icon-left pi pi-angle-right"></span>
                            </Button>
                        </template>
                    </Column>
                </DataTable>
            </div>

            <template #footer>
                <Button label="Cancel" icon="pi pi-times" class="p-button-text" @click="hideDialog"/>
                <Button label="Guardar" icon="pi pi-check" class="p-button-text" @click="saveDevice" />
            </template>
        </Dialog>

        <Dialog v-model:visible="deleteDeviceDialog" :style="{width: '450px'}" header="Confirm" :modal="true">
            <div class="confirmation-content">
                <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
                <span v-if="product">Estas seguro de querer eliminar<b>{{product.name}}</b>?</span>
            </div>
            <template #footer>
                <Button label="No" icon="pi pi-times" class="p-button-text" @click="deleteDeviceDialog = false"/>
                <Button label="Si" icon="pi pi-check" class="p-button-text" @click="deleteDevice" />
            </template>
        </Dialog>

        <Dialog v-model:visible="deleteDevicesDialog" :style="{width: '450px'}" header="Confirm" :modal="true">
            <div class="confirmation-content">
                <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
                <span v-if="product">Are you sure you want to delete the selected products?</span>
            </div>
            <template #footer>
                <Button label="No" icon="pi pi-times" class="p-button-text" @click="deleteDevicesDialog = false"/>
                <Button label="Si" icon="pi pi-check" class="p-button-text" @click="deleteSelectedProducts" />
            </template>
        </Dialog>

        <Dialog header="Parametrizar" v-model:visible="displayModal" :modal="true">
            <div class="field">
                <div class="surface-section px-4 py-5 md:px-6 lg:px-8">
                    <label for="description" class="block text-900 font-medium mb-2">Descripcion</label>
                    <InputText id="description" type="text" class="w-auto mb-3" v-model="nm" />

                    <label for="icon" class="block text-900 font-medium mb-2">Icono</label>
                    <InputText id="icon" type="text" class="w-auto mb-3" v-model="icon"/>

                    <label for="unit" class="block text-900 font-medium mb-2">Unidad</label>
                    <InputText id="unit" type="text" class="w-auto mb-3" v-model="unit"/>

                    <label for="unit" class="block text-900 font-medium mb-2">Valor inicial</label>
                    <InputNumber id="initial" class="w-auto mb-3" v-model="x0" mode="decimal" :minFractionDigits="1"/>

                    <label for="max" class="block text-900 font-medium mb-2">Max</label>
                    <InputNumber id="max" class="w-auto mb-3" v-model="max" mode="decimal" :minFractionDigits="1"/>

                    <label for="min" class="block text-900 font-medium mb-2">Min</label>
                    <InputNumber id="min" class="w-auto mb-3" v-model="min" mode="decimal" :minFractionDigits="1"/>
                </div>
            </div>
            <template #footer>
                <Button label="Cancel" class="p-button-text" @click="displayModal = false"></Button>
                <Button label="Guardar" @click.prevent="saveParameter"></Button>
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
            devices.value = await store.dispatch('get', { route: 'device' })
            parameters.value = await store.dispatch('get', { route: 'parameter' })
        })

        const devices = ref([])
        const id = ref()
        const mac = ref()
        const place = ref()
        const fixed = ref()
        const s = ref()

        const parameters = ref([])
        
        const dt = ref()
        const toast = useToast();
        const deviceDialog = ref(false)
        const deleteDeviceDialog = ref(false)
        const deleteDevicesDialog = ref(false)
        const selectedProducts = ref()
        const displayModal = ref(false)
        const nm = ref()
        const icon = ref()
        const unit = ref()
        const x0 = ref()
        const max = ref()
        const min = ref()
        let index = 0

        const filters = ref({
            'global': {value: null, matchMode: FilterMatchMode.CONTAINS},
        });
        const submitted = ref(false)
        const openNew = () => {
            id.value = null
            mac.value = null
            place.value = null
            fixed.value = null
            submitted.value = false
            deviceDialog.value = true
        }
        const editDevice = (p) => {
            id.value = p._id
            mac.value = p.mac
            place.value = p.place
            fixed.value = p.fixed
            s.value = p.s
            deviceDialog.value = true;
        }
        const selectedParameter = (data) => {
            index = data.index
            nm.value = data.data.nm
            icon.value = data.data.icon
            unit.value = data.data.unit
            x0.value = data.data.x0
            max.value = data.data.max
            min.value = data.data.min
            displayModal.value = true
        }
        const saveParameter = async () => {
            const data = {
                nm: nm.value,
                icon: icon.value,
                unit: unit.value,
                x0: x0.value,
                max: max.value,
                min: min.value
            }
            console.log(data)
            await store.dispatch('putId', { route: `device`, data: { data, index, s: s.value[index] }, id: id.value })
            displayModal.value = false
        }
        const hideDialog = () => {
            id.value = null
            mac.value = null
            place.value = null
            fixed.value = null
            deviceDialog.value = false
            submitted.value = false
        }
        const confirmDeleteDevice = (p) => {
            id.value = p._id
            deleteDeviceDialog.value = true;
        }
        const saveDevice = async () => {
            // CONTINUAR AQUI ################################################################
            // FALTA ARREGLAR EL ENVIO DE DATOS DATA, INDEX, S: DEVICE DATA VALUE S INDEX
            // ##########################################################################
            console.log(index)
            submitted.value = true
            if (!id.value) {
                await store.dispatch('post', { data: {mac: mac.value, place: place.value, fixed: fixed.value}, route: 'device' })
                toast.add({severity:'success', summary: 'Dispositivo creado', detail:'Se registro el nuevo dispositivo', life: 3000})
            } else {
                // await store.dispatch('putId', { data: {mac: mac.value, place: place.value, fixed: fixed.value}, route: 'device', id: id.value})
                await store.dispatch('putId', { route: `device`, data: { data:{ mac: mac.value, place: place.value }, s: s.value }, id: id.value })
                toast.add({severity:'success', summary: 'Dispositivo actualizado', detail:'Se actualizo el dispositivo', life: 3000})
            }
            deviceDialog.value = false;
            id.value = null
            mac.value = null
            place.value = null
            fixed.value = null
            submitted.value = false
            devices.value = await store.dispatch('get', { route: 'device' })
        }
        const deleteDevice = async () => {
            await store.dispatch('deleteId', { route: 'device', id: id.value })
            deleteDeviceDialog.value = false;
            id.value = null
            mac.value = null
            place.value = null
            fixed.value = null
            toast.add({severity:'warn', summary: 'Dispositivo eliminado', detail:'Se elimino el dispositivo de la BD', life: 3000});
            devices.value = await store.dispatch('get', { route: 'device' })
        }
        const findIndexById = (id) => {
            let index = -1;
            for (let i = 0; i < products.value.length; i++) {
                if (products.value[i].id === id) {
                    index = i;
                    break;
                }
            }

            return index;
        }
        const createId = () => {
            let id = '';
            var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            for ( var i = 0; i < 5; i++ ) {
                id += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            return id;
        }
        const exportCSV = () => {
            dt.value.exportCSV();
        }

        return { devices, mac, place, fixed, s, parameters, dt, deviceDialog, deleteDeviceDialog, deleteDevicesDialog,
            selectedProducts, filters, submitted, openNew, hideDialog, saveDevice, editDevice, confirmDeleteDevice, deleteDevice, 
            findIndexById, createId, exportCSV, selectedParameter, saveParameter, displayModal, nm, icon, unit, x0, max, min}
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
.p-chip.custom-chip {
    background: var(--yellow-400);
    color: var(--primary-color-text);
}
</style>