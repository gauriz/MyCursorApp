const JwtStrategy = require('passport-jwt').Strategy;
const ExtractJwt = require('passport-jwt').ExtractJwt;
const User = require('../models/User');

// Configure JWT options
const opts = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: process.env.JWT_SECRET
};

module.exports = (passport) => {
  passport.use(
    new JwtStrategy(opts, async (jwt_payload, done) => {
      try {
        // Find the user by id from the payload
        const user = await User.findById(jwt_payload.id);
        
        if (user) {
          // Return the user without password
          const { password, ...userWithoutPassword } = user;
          return done(null, userWithoutPassword);
        }
        
        // User not found
        return done(null, false);
      } catch (error) {
        console.error("Error in JWT strategy:", error);
        return done(error, false);
      }
    })
  );
}; 