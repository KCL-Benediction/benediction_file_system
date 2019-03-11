var express = require('express');
var router = express.Router();
var User = require("./../model/user.model.js");
var ObjectID = require('mongodb').ObjectID

/* Register. */
router.post('/register', function(req, res, next) {
	// Get a timestamp in seconds
	var timestamp = Math.floor(new Date().getTime()/1000);
	// Create a date with the timestamp
	var timestampDate = new Date(timestamp*1000);
	var objectId = new ObjectID(timestamp);
  var user = new User(
      {
          username: req.body.username,
          password: req.body.password,
          _id: objectId
      }
  );
  user.save(function(error){
  	if (error) {
  		return res.send({result: false, error:error})
  	}else{
  		return res.send({result: true, user: user})
  	}
  })
});

/* Login. */
router.post('/login', function(req, res, next) {
	var username = req.body.username;
	var password = req.body.password;
	User.find({
		username: username,
		password: password
	},function(error,users){
		if (users.length > 0) {
			return res.send({result:true});
		}else{
			return res.send({result:false, error: 'something wrong with the username or password'})
		}
	})
	
});



module.exports = router
