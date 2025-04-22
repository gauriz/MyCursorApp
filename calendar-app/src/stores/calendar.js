import { defineStore } from 'pinia'
import axios from 'axios'

// Create an axios instance for API calls
const api = axios.create({
  baseURL: 'http://localhost:3000/v1/internal',
  headers: {
    'Content-Type': 'application/json'
  }
})

export const useCalendarStore = defineStore('calendar', {
  state: () => ({
    notes: JSON.parse(localStorage.getItem('calendarNotes')) || {},
    user: null,
    token: localStorage.getItem('token') || null,
    loading: false,
    error: null
  }),
  
  actions: {
    async loginWithApi(username, password) {
      try {
        this.loading = true
        this.error = null
        
        const response = await api.post('/login', { username, password })
        
        if (response.data.success) {
          const { token, user } = response.data
          
          // Save token and user data
          this.token = token
          this.user = user.username
          
          // Store in localStorage
          localStorage.setItem('token', token)
          localStorage.setItem('calendarUser', user.username)
          
          // Set token in axios headers for future requests
          api.defaults.headers.common['Authorization'] = token
          
          return true
        } else {
          this.error = 'Invalid login attempt'
          return false
        }
      } catch (error) {
        console.error('Login error:', error)
        this.error = error.response?.data?.message || 'Login failed'
        return false
      } finally {
        this.loading = false
      }
    },
    
    async verifyToken() {
      if (!this.token) return false
      
      try {
        // Set the token in the headers
        api.defaults.headers.common['Authorization'] = this.token
        
        // Verify token with backend
        const response = await api.get('/verify')
        
        if (response.data.success) {
          this.user = response.data.user.username
          return true
        } else {
          this.logout()
          return false
        }
      } catch (error) {
        console.error('Token verification error:', error)
        this.logout()
        return false
      }
    },
    
    logout() {
      // Clear state
      this.user = null
      this.token = null
      
      // Remove from localStorage
      localStorage.removeItem('token')
      localStorage.removeItem('calendarUser')
      
      // Remove token from axios headers
      delete api.defaults.headers.common['Authorization']
    },
    
    addNote(date, note) {
      // Format date as YYYY-MM-DD
      const dateKey = new Date(date).toISOString().split('T')[0]
      
      if (!this.notes[dateKey]) {
        this.notes[dateKey] = []
      }
      
      // Only allow up to 3 notes per date
      if (this.notes[dateKey].length < 3) {
        this.notes[dateKey].push(note)
        this.saveToLocalStorage()
        return true
      }
      
      return false
    },
    
    deleteNote(date, index) {
      const dateKey = new Date(date).toISOString().split('T')[0]
      
      if (this.notes[dateKey] && index >= 0 && index < this.notes[dateKey].length) {
        this.notes[dateKey].splice(index, 1)
        this.saveToLocalStorage()
        return true
      }
      
      return false
    },
    
    saveToLocalStorage() {
      localStorage.setItem('calendarNotes', JSON.stringify(this.notes))
    }
  },
  
  getters: {
    isLoggedIn: (state) => !!state.user && !!state.token,
    
    getNotesForDate: (state) => (date) => {
      const dateKey = new Date(date).toISOString().split('T')[0]
      return state.notes[dateKey] || []
    },
    
    canAddNote: (state) => (date) => {
      const dateKey = new Date(date).toISOString().split('T')[0]
      return !state.notes[dateKey] || state.notes[dateKey].length < 3
    }
  }
}) 