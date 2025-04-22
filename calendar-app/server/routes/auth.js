const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const passport = require('passport');
const User = require('../models/User');

// Login route
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  
  // Simple validation
  if (!username || !password) {
    return res.status(400).json({ 
      success: false, 
      message: 'Please provide username and password' 
    });
  }
  
  try {
    // Authenticate user
    const user = await User.authenticate(username, password);
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }
    
    // Create JWT payload
    const payload = {
      id: user.id,
      username: user.username
    };
    
    // Sign the token
    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: '1d' },
      (err, token) => {
        if (err) {
          console.error('Error generating token:', err);
          return res.status(500).json({ 
            success: false, 
            message: 'Error generating token' 
          });
        }
        
        return res.json({
          success: true,
          token: `Bearer ${token}`,
          user
        });
      }
    );
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error during login'
    });
  }
});

// Sign-up route
router.post('/sign-up', async (req, res) => {
  const { username, password, firstName, lastName, dob } = req.body;
  
  // Simple validation
  if (!username || !password) {
    return res.status(400).json({ 
      success: false, 
      message: 'Please provide required fields' 
    });
  }
  
  try {
    // Check if user already exists
    const existingUser = await User.findByUsername(username);
    
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Username already exists'
      });
    }
    
    // Create new user
    const newUser = await User.create({
      username,
      password,
      firstName,
      lastName,
      dob
    });
    
    return res.status(201).json({
      success: true,
      message: 'User registered successfully',
      user: newUser
    });
  } catch (error) {
    console.error('Registration error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error during registration'
    });
  }
});

// Verify token route
router.get('/verify', 
  passport.authenticate('jwt', { session: false }),
  (req, res) => {
    res.json({ 
      success: true,
      user: {
        id: req.user.id,
        username: req.user.username
      }
    });
  }
);

module.exports = router; 