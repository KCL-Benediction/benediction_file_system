var express = require('express');
var router = express.Router();
var User = require("./../model/user.model.js");
var ObjectID = require('mongodb').ObjectID;
var jwt = require('jsonwebtoken');
var exjwt = require('express-jwt');
const authSecret = 'benediction-backend-auth-key';
var multer = require('multer');
var upload = multer({})
var md5 = require('md5');
/* Register. */
router.post('/register', upload.array(), function(req, res, next) {
	console.log(req.body.username,req.body.password)
	// Get a timestamp in seconds
	var timestamp = Math.floor(new Date().getTime()/1000);
	// Create a date with the timestamp
	var timestampDate = new Date(timestamp*1000);
	var objectId = new ObjectID(timestamp);
  var user = new User(
      {
          username: req.body.username,
          password: md5(req.body.password),
          firstname: req.body.firstname,
          lastname: req.body.lastname,
          _id: objectId
      }
  );
  user.save(function(error){
  	if (error) {
  		return res.send({result: false, error:error})
  	}else{
  		var responseUser = filterByKey(user,['username', 'firstname', 'lastname']);
  		return res.send({result: true, user: responseUser})
  	}
  })
});

/* Login. */
router.post('/login', upload.array(), function(req, res, next) {
	var username = req.body.username;
	var password = req.body.password;
	User.findOne({
		username: username,
		password: md5(password)
	},function(error, user){
		if (user) {
			var token = jwt.sign({
				id: user._id, 
				username: user.username 
			}, authSecret, {
				expiresIn: 129600 
			});
			var responseUser = filterByKey(user,['username', 'firstname', 'lastname']);
			console.log(responseUser);
			return res.send({
				result: true,
				token: token,
				user: responseUser
			});
		}else{
			return res.send({
				result:false, 
				error: 'something wrong with the username or password'
			})
		}
	})
	
});

function filterByKey(obj, keys){
	var newObj = {};
	for (var key in obj) {
		if (keys.indexOf(key) >= 0) {
			newObj[key] = obj[key]
		}
	}
	return newObj;
}



module.exports = router
