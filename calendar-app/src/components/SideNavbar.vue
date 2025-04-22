<template>
  <div class="sidebar-container" :class="{ 'sidebar-open': isSidebarOpen }">
    <button
      class="toggle-button"
      @click="toggleSidebar"
      :class="{ 'toggle-button-open': isSidebarOpen }"
      aria-label="Toggle sidebar"
    >
      <i class="fas fa-bars"></i>
    </button>

    <div class="sidebar" :class="{ 'sidebar-visible': isSidebarOpen }">
      <div class="user-info">
        <div class="user-avatar">
          <span>{{ userInitial }}</span>
        </div>
        <div class="user-details">
          <h3>{{ userName }}</h3>
          <p>{{ userEmail }}</p>
        </div>
      </div>
      
      <div class="nav-section">
        <h4>Main</h4>
        <nav-link to="/" icon="fa-calendar-alt">Calendar</nav-link>
        <nav-link to="/events" icon="fa-star">Events</nav-link>
        <nav-link to="/tasks" icon="fa-tasks">Tasks</nav-link>
      </div>

      <div class="nav-section">
        <h4>Personal</h4>
        <nav-link to="/notes" icon="fa-sticky-note">Notes</nav-link>
        <nav-link to="/contacts" icon="fa-address-book">Contacts</nav-link>
      </div>

      <div class="nav-section">
        <h4>Settings</h4>
        <nav-link to="/settings" icon="fa-cog">Settings</nav-link>
        <nav-link to="/profile" icon="fa-user">Profile</nav-link>
      </div>

      <div class="sidebar-footer">
        <button class="logout-button" @click="logout">
          <i class="fas fa-sign-out-alt"></i> Logout
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useCalendarStore } from '../stores/calendar';
import NavLink from './NavLink.vue';

export default {
  name: 'SideNavbar',
  components: {
    NavLink
  },
  setup() {
    const router = useRouter();
    const calendarStore = useCalendarStore();
    
    const isSidebarOpen = ref(false);
    
    const userName = computed(() => {
      return calendarStore.user || 'Guest User';
    });
    
    const userEmail = computed(() => {
      return localStorage.getItem('calendarUser') || 'guest@example.com';
    });
    
    const userInitial = computed(() => {
      return userName.value.charAt(0);
    });
    
    const toggleSidebar = () => {
      isSidebarOpen.value = !isSidebarOpen.value;
    };
    
    const logout = () => {
      calendarStore.logout();
      router.push('/');
    };
    
    return {
      isSidebarOpen,
      userName,
      userEmail,
      userInitial,
      toggleSidebar,
      logout
    };
  }
};
</script>

<style scoped>
.sidebar-container {
  position: relative;
  height: 100%;
}

.toggle-button {
  position: fixed;
  left: 16px;
  top: 16px;
  z-index: 1001;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: var(--primary-color);
  border: none;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: var(--elevation-2);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
}

.toggle-button:hover {
  background-color: var(--primary-color-dark);
  box-shadow: var(--elevation-3);
}

.toggle-button-open {
  left: calc(280px + 16px);
  background-color: var(--accent-color);
  color: var(--text-primary);
}

.toggle-button i {
  font-size: 1.25rem;
}

.sidebar {
  position: fixed;
  left: -280px;
  top: 0;
  width: 280px;
  height: 100vh;
  background-color: var(--bg-color);
  box-shadow: var(--elevation-4);
  z-index: 1000;
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  padding: 16px;
}

.sidebar-visible {
  transform: translateX(280px);
}

.user-info {
  display: flex;
  align-items: center;
  padding: 16px 8px 24px 8px;
  border-bottom: 1px solid var(--bg-color-dark);
  margin-bottom: 16px;
}

.user-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 12px;
  box-shadow: var(--elevation-1);
  background-color: var(--accent-color);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  font-weight: 500;
  color: var(--text-primary);
  font-family: "Dosis", sans-serif;
  font-optical-sizing: auto;
  font-style: normal;
}

.user-avatar span {
  line-height: 1;
}

.user-details h3 {
  font-size: 16px;
  font-weight: 300;
  margin: 0 0 4px 0;
  color: var(--text-primary);
  font-family: "Playwrite AU SA", cursive;
  font-optical-sizing: auto;
  font-style: normal;
}

.user-details p {
  font-size: 14px;
  margin: 0;
  color: var(--text-secondary);
  font-family: "Dosis", sans-serif;
  font-optical-sizing: auto;
  font-weight: 400;
  font-style: normal;
}

.nav-section {
  margin-bottom: 24px;
}

.nav-section h4 {
  font-size: 12px;
  text-transform: uppercase;
  color: var(--text-secondary);
  margin-bottom: 8px;
  padding: 0 var(--spacing-unit);
  letter-spacing: 0.5px;
  font-family: "Playwrite AU SA", cursive;
  font-optical-sizing: auto;
  font-weight: 300;
  font-style: normal;
}

.sidebar-footer {
  margin-top: auto;
  padding: 16px 0;
  border-top: 1px solid var(--bg-color-dark);
}

.logout-button {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 10px 16px;
  background-color: transparent;
  border: 1px solid var(--accent-color);
  border-radius: var(--border-radius);
  color: var(--text-primary);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: "Dosis", sans-serif;
  font-optical-sizing: auto;
  font-style: normal;
}

.logout-button:hover {
  background-color: var(--accent-color-light);
  color: var(--accent-color-dark);
}

.logout-button i {
  margin-right: 8px;
}

@media (max-width: 768px) {
  .sidebar {
    width: 240px;
    left: -240px;
  }
  
  .sidebar-visible {
    transform: translateX(240px);
  }
  
  .toggle-button-open {
    left: calc(240px + 16px);
  }
}
</style> 