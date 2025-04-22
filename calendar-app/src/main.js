import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { createRouter, createWebHistory } from 'vue-router'
import axios from 'axios'
import App from './App.vue'

// Routes
import Login from './views/Login.vue'
import Signup from './views/Signup.vue'
import Calendar from './views/Calendar.vue'

// Configure axios defaults
axios.defaults.baseURL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/v1/internal'

// Add token to axios headers if exists
const token = localStorage.getItem('token')
if (token) {
  axios.defaults.headers.common['Authorization'] = token
}

const routes = [
  { path: '/', name: 'Login', component: Login },
  { path: '/signup', name: 'Signup', component: Signup },
  { path: '/calendar', name: 'Calendar', component: Calendar }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Navigation guard to check authentication
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('token')
  
  if (to.name !== 'Login' && to.name !== 'Signup' && !isAuthenticated) {
    next({ name: 'Login' })
  } else {
    next()
  }
})

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
