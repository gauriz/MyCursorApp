require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const passport = require('passport');
const path = require('path');

// Import database configuration
const { testConnection, initDatabase } = require('./config/database');

// Import routes
const authRoutes = require('./routes/auth');

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 3000;

// Configure passport
require('./config/passport')(passport);

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(passport.initialize());

// Routes
app.use('/v1/internal', authRoutes);

// Basic route for testing
app.get('/', (req, res) => {
  res.json({ message: 'My Personal lil App API is running' });
});

// Protected route example
app.get('/v1/internal/protected', 
  passport.authenticate('jwt', { session: false }), 
  (req, res) => {
    res.json({ 
      message: 'You have accessed a protected route',
      user: {
        id: req.user.id,
        username: req.user.username
      }
    });
  }
);

// Initialize database and start server
async function startServer() {
  try {
    // Test database connection
    await testConnection();
    
    // Initialize database tables
    await initDatabase();
    
    // Start the server
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer(); 