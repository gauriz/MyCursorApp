const bcrypt = require('bcryptjs');
const { pool } = require('../config/database');

const User = {
  // Find user by username
  findByUsername: async (username) => {
    try {
      const [rows] = await pool.query('SELECT * FROM users WHERE username = ?', [username]);
      return rows.length > 0 ? rows[0] : null;
    } catch (error) {
      console.error('Error finding user by username:', error);
      return null;
    }
  },
  
  // Find user by ID
  findById: async (id) => {
    try {
      const [rows] = await pool.query('SELECT * FROM users WHERE id = ?', [id]);
      return rows.length > 0 ? rows[0] : null;
    } catch (error) {
      console.error('Error finding user by id:', error);
      return null;
    }
  },
  
  // Authenticate user with bcrypt password comparison
  authenticate: async (username, password) => {
    try {
      const user = await User.findByUsername(username);
      
      if (!user) {
        return null;
      }
      
      // Compare passwords using bcrypt
      const isMatch = await bcrypt.compare(password, user.password);
      
      if (isMatch) {
        // Return user data without password
        const { password, ...userWithoutPassword } = user;
        return userWithoutPassword;
      }
      
      return null;
    } catch (error) {
      console.error('Error authenticating user:', error);
      return null;
    }
  },
  
  // Create a new user
  create: async (userData) => {
    try {
      // Hash the password
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(userData.password, salt);
      
      // Insert user into database
      const [result] = await pool.query(
        'INSERT INTO users (username, password, firstName, lastName, dob) VALUES (?, ?, ?, ?, ?)',
        [userData.username, hashedPassword, userData.firstName, userData.lastName, userData.dob]
      );
      
      // Return the new user without password
      const newUser = {
        id: result.insertId,
        username: userData.username,
        firstName: userData.firstName,
        lastName: userData.lastName,
        dob: userData.dob
      };
      
      return newUser;
    } catch (error) {
      console.error('Error creating user:', error);
      throw error;
    }
  }
};

module.exports = User; 