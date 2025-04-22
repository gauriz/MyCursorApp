<template>
  <div class="calendar-container">
    <!-- Side Navigation -->
    <SideNavbar />
    
    <header class="beauty-header">
      <div class="header-content">
        <h1>My Personal lil App</h1>
        <div class="user-info">
          <span>Hello {{ calendarStore.user }}</span>
          <button @click="logout" class="blue-btn logout-btn">Sign Out</button>
        </div>
      </div>
    </header>
    
    <main class="main-content">
      <div class="calendar-layout card">
        <div class="calendar-nav">
          <button @click="prevMonth" class="blue-btn nav-btn">&lt;</button>
          <h2>{{ currentMonthName }} {{ currentYear }}</h2>
          <button @click="nextMonth" class="blue-btn nav-btn">&gt;</button>
        </div>
        
        <div class="days-header">
          <div v-for="day in weekdays" :key="day" class="day-name">{{ day }}</div>
        </div>
        
        <div class="calendar-grid">
          <div 
            v-for="day in calendarDays" 
            :key="day.date" 
            class="calendar-day" 
            :class="{ 
              'current-month': day.currentMonth, 
              'today': day.isToday,
              'selected': isSelectedDate(day.date)
            }"
            @click="selectDate(day.date)"
          >
            <div class="day-number">{{ day.dayNumber }}</div>
            <div v-if="day.hasNotes" class="note-indicator">
              <div 
                v-for="(note, index) in getNotesForDay(day.date)" 
                :key="index" 
                class="note-preview"
              >
                {{ truncateNote(note) }}
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div v-if="selectedDate" class="notes-panel card">
        <h3>Notes for {{ formatDate(selectedDate) }}</h3>
        
        <div class="notes-list">
          <div 
            v-for="(note, index) in selectedDateNotes" 
            :key="index" 
            class="note-item"
          >
            <p>{{ note }}</p>
            <button @click="deleteNote(index)" class="delete-note">×</button>
          </div>
          
          <div v-if="selectedDateNotes.length === 0" class="empty-notes">
            No notes for this date
          </div>
        </div>
        
        <div v-if="canAddNote" class="add-note-form">
          <textarea 
            v-model="newNote" 
            placeholder="Add note or reminder..." 
            rows="3"
            :maxlength="150"
          ></textarea>
          <button 
            @click="addNote" 
            class="blue-btn add-note-btn" 
            :disabled="!newNote.trim()"
          >
            Add Note
          </button>
        </div>
        <div v-else class="max-notes-warning">
          Maximum notes reached for this date (3)
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCalendarStore } from '../stores/calendar'
import SideNavbar from '../components/SideNavbar.vue'

export default {
  name: 'CalendarView',
  components: {
    SideNavbar
  },
  setup() {
    const router = useRouter()
    const calendarStore = useCalendarStore()
    
    // Check for auth token and verify it
    onMounted(async () => {
      if (calendarStore.token) {
        // Verify token with backend
        const isValid = await calendarStore.verifyToken()
        
        if (!isValid) {
          router.push('/')
        }
      } else {
        router.push('/')
      }
    })
    
    const currentDate = ref(new Date())
    const selectedDate = ref(new Date())
    const newNote = ref('')
    
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    
    const currentYear = computed(() => currentDate.value.getFullYear())
    const currentMonth = computed(() => currentDate.value.getMonth())
    const currentMonthName = computed(() => {
      return new Intl.DateTimeFormat('en-US', { month: 'long' }).format(currentDate.value)
    })
    
    const calendarDays = computed(() => {
      const year = currentYear.value
      const month = currentMonth.value
      
      // First day of the month
      const firstDay = new Date(year, month, 1)
      // Last day of the month
      const lastDay = new Date(year, month + 1, 0)
      
      // Get the day of the week of the first day (0-6, where 0 is Sunday)
      const firstDayOfWeek = firstDay.getDay()
      
      // Array to hold all the days we'll display
      const days = []
      
      // Add days from previous month to fill the first row
      const prevMonthLastDay = new Date(year, month, 0).getDate()
      for (let i = 0; i < firstDayOfWeek; i++) {
        const date = new Date(year, month - 1, prevMonthLastDay - firstDayOfWeek + i + 1)
        days.push({
          date,
          dayNumber: date.getDate(),
          currentMonth: false,
          isToday: isSameDay(date, new Date()),
          hasNotes: hasNotes(date)
        })
      }
      
      // Add days from current month
      for (let i = 1; i <= lastDay.getDate(); i++) {
        const date = new Date(year, month, i)
        days.push({
          date,
          dayNumber: i,
          currentMonth: true,
          isToday: isSameDay(date, new Date()),
          hasNotes: hasNotes(date)
        })
      }
      
      // Add days from next month to complete the grid (6 rows x 7 columns = 42 cells)
      const daysNeeded = 42 - days.length
      for (let i = 1; i <= daysNeeded; i++) {
        const date = new Date(year, month + 1, i)
        days.push({
          date,
          dayNumber: i,
          currentMonth: false,
          isToday: isSameDay(date, new Date()),
          hasNotes: hasNotes(date)
        })
      }
      
      return days
    })
    
    const selectedDateNotes = computed(() => {
      return calendarStore.getNotesForDate(selectedDate.value)
    })
    
    const canAddNote = computed(() => {
      return calendarStore.canAddNote(selectedDate.value)
    })
    
    // Helper functions
    const isSameDay = (date1, date2) => {
      return date1.getDate() === date2.getDate() &&
        date1.getMonth() === date2.getMonth() &&
        date1.getFullYear() === date2.getFullYear()
    }
    
    const hasNotes = (date) => {
      return calendarStore.getNotesForDate(date).length > 0
    }
    
    const isSelectedDate = (date) => {
      return isSameDay(date, selectedDate.value)
    }
    
    const formatDate = (date) => {
      return new Intl.DateTimeFormat('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
      }).format(date)
    }
    
    const truncateNote = (note) => {
      return note.length > 15 ? note.substring(0, 15) + '...' : note
    }
    
    // Actions
    const nextMonth = () => {
      currentDate.value = new Date(currentYear.value, currentMonth.value + 1, 1)
    }
    
    const prevMonth = () => {
      currentDate.value = new Date(currentYear.value, currentMonth.value - 1, 1)
    }
    
    const selectDate = (date) => {
      selectedDate.value = date
    }
    
    const addNote = () => {
      if (newNote.value.trim() && canAddNote.value) {
        calendarStore.addNote(selectedDate.value, newNote.value.trim())
        newNote.value = ''
      }
    }
    
    const deleteNote = (index) => {
      calendarStore.deleteNote(selectedDate.value, index)
    }
    
    const getNotesForDay = (date) => {
      return calendarStore.getNotesForDate(date)
    }
    
    const logout = () => {
      calendarStore.logout()
      router.push('/')
    }
    
    return {
      calendarStore,
      currentDate,
      selectedDate,
      newNote,
      weekdays,
      currentYear,
      currentMonth,
      currentMonthName,
      calendarDays,
      selectedDateNotes,
      canAddNote,
      nextMonth,
      prevMonth,
      selectDate,
      addNote,
      deleteNote,
      isSelectedDate,
      formatDate,
      truncateNote,
      getNotesForDay,
      logout
    }
  }
}
</script>

<style scoped>
.calendar-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: var(--lighter-cream);
}

.beauty-header {
  background: linear-gradient(135deg, var(--primary-color), var(--dark-brown));
  color: var(--text-light);
  padding: 0;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.beauty-header h1 {
  font-weight: 300;
  margin: 0;
  letter-spacing: 1px;
  font-size: 28px;
  font-family: "Playwrite AU SA", cursive;
  font-optical-sizing: auto;
  font-style: normal;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 20px;
}

.logout-btn {
  padding: 8px 16px;
  font-size: 12px;
}

.main-content {
  flex: 1;
  padding: 40px 20px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
  display: flex;
  flex-wrap: wrap;
  gap: 30px;
}

.calendar-layout {
  flex: 2;
  min-width: 600px;
}

.calendar-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.calendar-nav h2 {
  font-weight: 300;
  color: var(--accent-color);
  margin: 0;
  letter-spacing: 0.5px;
  font-family: "Playwrite AU SA", cursive;
  font-optical-sizing: auto;
  font-style: normal;
}

.nav-btn {
  min-width: 40px;
  padding: 8px 14px;
}

.days-header {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  text-align: center;
  font-weight: 500;
  margin-bottom: 10px;
  background-color: var(--primary-color);
  color: var(--text-light);
  border-radius: 4px;
}

.day-name {
  padding: 12px;
  letter-spacing: 1px;
  font-family: "Dosis", sans-serif;
  font-optical-sizing: auto;
  font-weight: 600;
  font-style: normal;
}

.calendar-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  grid-gap: 8px;
  margin-bottom: 20px;
}

.calendar-day {
  min-height: 100px;
  padding: 8px;
  border-radius: 4px;
  background-color: white;
  cursor: pointer;
  position: relative;
  border: 1px solid var(--border-color);
  transition: all 0.2s ease;
}

.calendar-day:hover {
  background-color: var(--lighter-cream);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
}

.calendar-day.current-month {
  background-color: white;
}

.calendar-day:not(.current-month) {
  background-color: rgba(255, 255, 255, 0.7);
  color: #999;
}

.calendar-day.today {
  border: 2px solid var(--accent-color);
}

.calendar-day.selected {
  background-color: var(--light-brown);
  border-color: var(--primary-color);
}

.day-number {
  font-weight: 600;
  margin-bottom: 8px;
  color: var(--accent-color);
  font-family: "Dosis", sans-serif;
  font-optical-sizing: auto;
  font-style: normal;
}

.note-indicator {
  font-size: 0.8em;
  margin-top: 5px;
}

.note-preview {
  margin-bottom: 4px;
  padding: 4px 6px;
  background-color: var(--light-brown);
  border-radius: 3px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 0.9em;
}

.notes-panel {
  flex: 1;
  min-width: 300px;
}

.notes-panel h3 {
  font-weight: 300;
  color: var(--accent-color);
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 20px;
  letter-spacing: 0.5px;
  font-family: "Playwrite AU SA", cursive;
  font-optical-sizing: auto;
  font-style: normal;
}

.notes-list {
  margin-bottom: 20px;
}

.note-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  margin-bottom: 10px;
  background-color: var(--lighter-cream);
  border-radius: 4px;
  border-left: 3px solid var(--primary-color);
}

.note-item p {
  margin: 0;
  flex: 1;
}

.empty-notes {
  padding: 30px 20px;
  text-align: center;
  color: #888;
  font-style: italic;
  background-color: var(--lighter-cream);
  border-radius: 4px;
}

.delete-note {
  background-color: var(--error-color);
  color: white;
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: 10px;
  transition: all 0.2s;
}

.delete-note:hover {
  transform: scale(1.1);
  background-color: #d32f2f;
}

.add-note-form {
  display: flex;
  flex-direction: column;
}

textarea {
  padding: 15px;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  resize: vertical;
  margin-bottom: 15px;
  font-family: "Dosis", sans-serif;
  font-optical-sizing: auto;
  font-weight: 400;
  font-style: normal;
  background-color: rgba(255, 255, 255, 0.8);
}

textarea:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(139, 110, 79, 0.2);
}

.add-note-btn {
  align-self: flex-end;
  padding: 10px 20px;
}

.max-notes-warning {
  color: var(--error-color);
  text-align: center;
  padding: 15px;
  background-color: rgba(177, 75, 75, 0.1);
  border-radius: 4px;
  font-size: 0.9em;
}

@media (max-width: 992px) {
  .main-content {
    flex-direction: column;
  }
  
  .calendar-layout, .notes-panel {
    min-width: 0;
    width: 100%;
  }
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    text-align: center;
    padding: 15px;
  }
  
  .user-info {
    margin-top: 10px;
    flex-direction: column;
    gap: 10px;
  }
  
  .calendar-nav h2 {
    font-size: 1.2rem;
  }
  
  .main-content {
    padding: 20px 10px;
  }
  
  .calendar-day {
    min-height: 80px;
  }
}

@media (max-width: 480px) {
  .add-note-btn {
    width: 100%;
    align-self: center;
  }
  
  .calendar-day {
    min-height: 60px;
    padding: 4px;
  }
  
  .day-name {
    padding: 8px 5px;
    font-size: 0.9em;
  }
  
  .calendar-grid {
    grid-gap: 4px;
  }
  
  .day-number {
    font-size: 0.9em;
  }
}
</style> 