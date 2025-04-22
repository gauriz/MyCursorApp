<template>
  <div class="signup-container">
    <div class="card signup-card">
      <div class="branding">
        <div class="logo-container">
          <img src="https://i.pinimg.com/originals/a9/41/22/a941225cfdb7105ccbde588be0374c28.jpg" alt="Valorant Agent Clove" class="clove-image">
        </div>
        <h3 class="app-title">My Personal lil App</h3>
        <p class="tagline">Create your account</p>
      </div>
      <div class="signup-form-container">
        <h2>Sign Up</h2>
        <form @submit.prevent="handleSignup">
          <div class="form-row">
            <div class="form-control">
              <label for="firstName">First Name</label>
              <input 
                type="text" 
                id="firstName" 
                v-model="firstName" 
                placeholder="Enter your first name"
                required
              />
            </div>
            <div class="form-control">
              <label for="lastName">Last Name</label>
              <input 
                type="text" 
                id="lastName" 
                v-model="lastName" 
                placeholder="Enter your last name"
                required
              />
            </div>
          </div>
          
          <div class="form-control">
            <label for="username">Username</label>
            <input 
              type="text" 
              id="username" 
              v-model="username" 
              placeholder="Choose a username"
              required
            />
          </div>
          
          <div class="form-control">
            <label for="password">Password</label>
            <input 
              type="password" 
              id="password" 
              v-model="password" 
              placeholder="Choose a password"
              required
            />
          </div>
          
          <div class="form-control">
            <label for="dob">Date of Birth</label>
            <div class="date-picker-container">
              <input 
                type="date" 
                id="dob" 
                v-model="dob" 
                required
              />
            </div>
          </div>
          
          <div v-if="error" class="error-message">
            {{ error }}
          </div>
          
          <div v-if="successMessage" class="success-message">
            {{ successMessage }}
          </div>
          
          <div class="form-actions">
            <button 
              type="submit" 
              class="blue-btn signup-btn" 
              :disabled="!isFormValid || loading"
            >
              <span v-if="loading">Registering...</span>
              <span v-else>Create Account</span>
            </button>
            
            <div class="login-link">
              Already have an account? <router-link to="/">Login</router-link>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

export default {
  name: 'SignupView',
  setup() {
    const router = useRouter()
    
    // Form fields
    const username = ref('')
    const password = ref('')
    const firstName = ref('')
    const lastName = ref('')
    const dob = ref('')
    
    // UI states
    const loading = ref(false)
    const error = ref('')
    const successMessage = ref('')
    
    const isFormValid = computed(() => {
      return username.value.trim() !== '' && 
             password.value.trim() !== '' &&
             firstName.value.trim() !== '' &&
             lastName.value.trim() !== '' &&
             dob.value !== '';
    })
    
    const handleSignup = async () => {
      if (!isFormValid.value) return;
      
      loading.value = true;
      error.value = '';
      successMessage.value = '';
      
      try {
        const response = await axios.post('/sign-up', {
          username: username.value,
          password: password.value,
          firstName: firstName.value,
          lastName: lastName.value,
          dob: dob.value
        });
        
        if (response.data.success) {
          successMessage.value = 'Account created successfully!';
          
          // Reset form fields
          username.value = '';
          password.value = '';
          firstName.value = '';
          lastName.value = '';
          dob.value = '';
          
          // Redirect to login after a short delay
          setTimeout(() => {
            router.push('/');
          }, 2000);
        } else {
          error.value = response.data.message || 'Error creating account';
        }
      } catch (err) {
        console.error('Signup error:', err);
        error.value = err.response?.data?.message || 'Error creating account';
      } finally {
        loading.value = false;
      }
    }
    
    return {
      username,
      password,
      firstName,
      lastName,
      dob,
      loading,
      error,
      successMessage,
      isFormValid,
      handleSignup
    }
  }
}
</script>

<style scoped>
.signup-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: url('https://i.pinimg.com/originals/5f/0c/36/5f0c36287843a096032f42051132fabb.jpg') center/cover;
  position: relative;
}

.signup-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(100, 181, 246, 0.5); /* Blue overlay */
}

.signup-card {
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

.signup-form-container {
  flex: 1.5;
  padding: 40px;
  background-color: white;
  overflow-y: auto;
  max-height: 90vh;
}

.signup-form-container h2 {
  color: var(--accent-color);
  margin-bottom: 30px;
  font-size: 28px;
  font-weight: 300;
  font-family: "Playwrite AU SA", cursive;
  font-optical-sizing: auto;
  font-style: normal;
}

.form-row {
  display: flex;
  gap: 15px;
  margin-bottom: 5px;
}

.form-control {
  margin-bottom: 20px;
  width: 100%;
}

.form-actions {
  margin-top: 30px;
}

.signup-btn {
  width: 100%;
  margin-bottom: 20px;
  padding: 12px;
}

.login-link {
  text-align: center;
  margin-top: 10px;
  color: #666;
}

.login-link a {
  color: var(--primary-color);
  text-decoration: none;
  font-weight: 500;
}

.login-link a:hover {
  text-decoration: underline;
}

.date-picker-container {
  position: relative;
}

input[type="date"] {
  width: 100%;
  padding: 10px;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  font-size: 16px;
  background-color: rgba(255, 255, 255, 0.8);
  font-family: inherit;
}

.error-message {
  color: var(--error-color);
  margin-top: 15px;
  padding: 10px;
  background-color: rgba(177, 75, 75, 0.1);
  border-radius: 4px;
  text-align: center;
}

.success-message {
  color: var(--success-color);
  margin-top: 15px;
  padding: 10px;
  background-color: rgba(106, 139, 106, 0.1);
  border-radius: 4px;
  text-align: center;
}

@media (max-width: 768px) {
  .signup-card {
    flex-direction: column;
    max-width: 500px;
  }
  
  .branding, .signup-form-container {
    padding: 30px;
  }
  
  .form-row {
    flex-direction: column;
    gap: 0;
  }
}

@media (max-width: 480px) {
  .signup-card {
    margin: 0 15px;
  }
  
  .branding, .signup-form-container {
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