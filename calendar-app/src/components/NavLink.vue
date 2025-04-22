<template>
  <router-link :to="to" class="nav-link" :class="{ active: isActive }">
    <i :class="['fas', icon]"></i>
    <slot></slot>
  </router-link>
</template>

<script>
import { computed } from 'vue';
import { useRoute } from 'vue-router';

export default {
  name: 'NavLink',
  props: {
    to: {
      type: String,
      required: true
    },
    icon: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const route = useRoute();
    
    const isActive = computed(() => {
      return route.path === props.to;
    });
    
    return {
      isActive
    };
  }
};
</script>

<style scoped>
.nav-link {
  display: flex;
  align-items: center;
  padding: calc(var(--spacing-unit) * 1.5) var(--spacing-unit);
  margin: var(--spacing-unit) 0;
  text-decoration: none;
  color: var(--text-primary);
  border-radius: var(--border-radius);
  transition: background-color 0.3s cubic-bezier(0.4, 0, 0.2, 1), 
              box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  font-family: "Dosis", sans-serif;
  font-optical-sizing: auto;
  font-weight: 500;
  font-style: normal;
}

.nav-link:hover {
  background-color: rgba(100, 181, 246, 0.08); /* Light sky blue */
}

.nav-link.active {
  background-color: var(--primary-color-light);
  box-shadow: var(--elevation-1);
  color: var(--primary-color-dark);
  font-weight: 500;
}

.nav-link:active {
  background-color: rgba(100, 181, 246, 0.16);
}

.nav-link i {
  margin-right: var(--spacing-unit);
  font-size: 1.25rem;
  width: 24px;
  text-align: center;
  color: var(--text-secondary);
}

.nav-link.active i {
  color: var(--primary-color);
}

/* Material Design ripple effect */
.nav-link::after {
  content: "";
  display: block;
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  pointer-events: none;
  background-image: radial-gradient(circle, #000 10%, transparent 10.01%);
  background-repeat: no-repeat;
  background-position: 50%;
  transform: scale(10, 10);
  opacity: 0;
  transition: transform 0.5s, opacity 1s;
}

.nav-link:active::after {
  transform: scale(0, 0);
  opacity: 0.2;
  transition: 0s;
}
</style> 