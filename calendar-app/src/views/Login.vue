<template>
  <div class="login-container">
    <div class="card login-card">
      <div class="branding">
        <div class="logo-container">
          <img src="https://i.pinimg.com/originals/a9/41/22/a941225cfdb7105ccbde588be0374c28.jpg" alt="Valorant Agent Clove" class="clove-image">
        </div>
        <h3 class="app-title">My Personal lil App</h3>
        <p class="tagline">Keep track of your routines</p>
      </div>
      <div class="login-form-container">
        <h2>Sign In</h2>
        <form @submit.prevent="handleLogin">
          <div class="form-control">
            <label for="username">Username</label>
            <input 
              type="text" 
              id="username" 
              v-model="username" 
              placeholder="Enter your username"
              required
            />
          </div>
          <div class="form-control">
            <label for="password">Password</label>
            <input 
              type="password" 
              id="password" 
              v-model="password" 
              placeholder="Enter your password"
              required
            />
          </div>
          
          <div v-if="calendarStore.error" class="error-message">
            {{ calendarStore.error }}
          </div>
          
          <div class="form-actions">
            <button 
              type="submit" 
              class="blue-btn login-btn" 
              :disabled="!isFormValid || calendarStore.loading"
            >
              <span v-if="calendarStore.loading">Logging in...</span>
              <span v-else>Enter</span>
            </button>
            
            <div class="divider">
              <span>or</span>
            </div>
            
            <router-link to="/signup" class="signup-btn">
              Create New Account
            </router-link>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useCalendarStore } from '../stores/calendar'

export default {
  name: 'LoginView',
  setup() {
    const username = ref('')
    const password = ref('')
    const router = useRouter()
    const calendarStore = useCalendarStore()

    const isFormValid = computed(() => {
      return username.value.trim() !== '' && password.value.trim() !== ''
    })

    const handleLogin = async () => {
      if (await calendarStore.loginWithApi(username.value, password.value)) {
        router.push('/calendar')
      }
    }

    return {
      username,
      password,
      calendarStore,
      isFormValid,
      handleLogin
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: url('https://i.pinimg.com/originals/5f/0c/36/5f0c36287843a096032f42051132fabb.jpg') center/cover;
  position: relative;
}

.login-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(100, 181, 246, 0.5); /* Blue overlay */
}

.login-card {
  width: 100%;
  max-width: 900px;
  display: flex;
  position: relative;
  z-index: 1;
  overflow: hidden;
  padding: 0;
}

.branding {
  background: linear-gradient(135deg, var(--primary-color), var(--dark-brown));
  color: var(--text-light);
  padding: 60px 40px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.branding h1 {
  font-size: 36px;
  margin-bottom: 20px;
  font-weight: 700;
}

.tagline {
  font-size: 18px;
  opacity: 0.9;
  font-weight: 300;
  margin-bottom: 30px;
  font-family: "Dosis", sans-serif;
  font-optical-sizing: auto;
  font-style: normal;
}

.login-form-container {
  flex: 1;
  padding: 60px 40px;
  background-color: white;
}

.login-form-container h2 {
  color: var(--accent-color);
  margin-bottom: 30px;
  font-size: 28px;
  font-weight: 300;
  font-family: "Playwrite AU SA", cursive;
  font-optical-sizing: auto;
  font-style: normal;
}

.form-actions {
  margin-top: 30px;
}

.login-btn {
  width: 100%;
  padding: 12px;
}

.error-message {
  color: var(--error-color);
  margin-top: 15px;
  padding: 10px;
  background-color: rgba(177, 75, 75, 0.1);
  border-radius: 4px;
  text-align: center;
}

.divider {
  text-align: center;
  margin: 20px 0;
  position: relative;
}

.divider::before, .divider::after {
  content: '';
  position: absolute;
  top: 50%;
  width: calc(50% - 30px);
  height: 1px;
  background-color: var(--border-color);
}

.divider::before {
  left: 0;
}

.divider::after {
  right: 0;
}

.divider span {
  display: inline-block;
  padding: 0 15px;
  background-color: white;
  position: relative;
  color: #777;
  font-size: 14px;
}

.signup-btn {
  display: block;
  text-align: center;
  padding: 12px;
  border: 1px solid var(--primary-color);
  border-radius: 4px;
  color: var(--primary-color);
  font-weight: 500;
  text-decoration: none;
  transition: all 0.3s ease;
}

.signup-btn:hover {
  background-color: rgba(139, 110, 79, 0.05);
}

@media (max-width: 768px) {
  .login-card {
    flex-direction: column;
    max-width: 400px;
  }
  
  .branding, .login-form-container {
    padding: 30px;
  }
}

@media (max-width: 480px) {
  .login-card {
    margin: 0 15px;
  }
  
  .branding, .login-form-container {
    padding: 20px;
  }
  
  .branding h1 {
    font-size: 28px;
  }
}

.logo-container {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
  width: 100%;
}

.clove-image {
  width: 100%;
  height: auto;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

.app-title {
  text-align: center;
  color: white;
  font-size: 24px;
  margin: 15px 0;
  font-weight: 300;
  font-family: "Playwrite AU SA", cursive;
  font-optical-sizing: auto;
  font-style: normal;
}
</style> 