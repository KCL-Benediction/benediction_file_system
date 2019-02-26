var express = require('express');
var router = express.Router();
var fs = require("fs");
var randomstring = require("randomstring");
var multer = require('multer');
var app = require('./../app');
var upload = multer({ 
	dest: './temp/'
});
const baseAPI = 'http://51.140.187.17';


module.exports = (wss) =>{ 
	// get files
	router.get('/get_all_file_details',upload.array(), (req, res) => {
		fs.readFile("./files/files.json","utf-8",(error, content)=>{
			var file_dictionary = JSON.parse(content);
			var files = [];
			for (file_id in file_dictionary) {
				var file = file_dictionary[file_id];
				file['file_id'] = file_id;
				file['url'] = baseAPI + '/download_a_file?file_id='+file_id;
				files.push(file)
			}
			return res.send({result: true, files: files})
		})
	})

	// change_file_names
	router.post('/change_file_name',upload.array(), (req, res) => {
		fs.readFile("./files/files.json","utf-8",(error, content)=>{
			var file_dictionary = JSON.parse(content);
			var file_id = req.body.file_id;
			var file_new_name = req.body.file_new_name;
			if (!file_id || !file_new_name) {
				return res.send({result: false, reason: "the request missed some data"});
			}else if (file_id in file_dictionary) {
				fs.rename('./files/'+file_dictionary[file_id]['file_name'], './files/'+file_new_name, function(err) {
				    if ( err ){
				    	console.log(err)
				    	return res.send({result: false, reason: "error on changing the name on server"});
				    }else{
				    	file_dictionary[file_id]['file_name'] = file_new_name;
				    	fs.writeFile("./files/files.json", JSON.stringify(file_dictionary),()=>{
								send_websocket_event({
								    "event": "file_name_changed",
								    "file_name": file_dictionary[file_id]['file_name'],
								    "file_id": file_id
								})
				    		return res.send({result: true})
				    	})
				    }
				});
			}else{
				return res.send({result: false, reason: "no such a file"})
			}
		})
	})

	// delete a file
	router.post('/delete_a_file',upload.array(), (req,res)=>{
		fs.readFile("./files/files.json","utf-8",(error, content)=>{
			var file_dictionary = JSON.parse(content);
			var file_id = req.body.file_id;
			if (!file_id) {
				return res.send({result: false, reason: "the request missed some data"});
			}else if (file_id in file_dictionary) {
				fs.unlink('./files/'+file_dictionary[file_id]['file_name'], (err) => {
			  	if ( err ){
			    	console.log(err)
			    	return res.send({result: false, reason: "error on delting the file on server"});
			    }else{
			    	delete file_dictionary[file_id];
			    	fs.writeFile("./files/files.json", JSON.stringify(file_dictionary),()=>{
							send_websocket_event({
							    "event": "file_deleted",
							    "file_id": file_id
							})
			    		return res.send({result: true})
			    	})
			    }
				});
			}else{
				return res.send({result: false, reason: "no such a file"})
			}
		})
	})

	// download
	router.get('/download_a_file', (req,res)=>{
		fs.readFile("./files/files.json","utf-8",(error, content)=>{
			var file_dictionary = JSON.parse(content);
			var file_id = req.param('file_id');
			if (!file_id) {
				return res.send({result: false, reason: "the request missed some data"});
			}else if (file_id in file_dictionary) {
				return res.download( process.env.PWD + '/files/'+file_dictionary[file_id]['file_name'])
			}else{
				return res.send({result: false, reason: "no such a file"})
			}
		})
	})

	// upload a file
	router.post(
		'/upload_a_file',
		multer({ 
			dest: './temp/',
	    onFileUploadStart: function (file) {
	        // recentFile = file;
	        // recentFile.finished = false;
	        console.log(file.originalname + ' is starting ...')
	    },
	    onFileUploadComplete: function (file) {
	        // recentFile.finished = true;
	    }
		}).single('file'), 
		(req, res) => {
			fs.readFile("./files/files.json","utf-8",(error, content)=>{
				var file_dictionary = JSON.parse(content);
				var uploadedFile = req.file;
				var type = req.body.type;
				var file_name = req.body.file_name;
				var file_id = req.body.file_id;
				if (!uploadedFile) {
					return res.send({result: false, reason: 'no file received'});
				}else if (type == 'new') {
					if (!file_name) {
						remove_file(uploadedFile)
						return res.send({result: false, reason: "the request missed some data"});
					}
					var file_name_conflict = false;
					for (file_id in file_dictionary) {
						if(file_dictionary[file_id]['file_name'] == file_name){
							file_name_conflict = true;
							break
						}
					}
					if (file_name_conflict) {
						remove_file(uploadedFile)
						return res.send({result: false, reason: "file name confilct"})
					}else{
						var new_id = randomstring.generate();
						var new_file_dictionary = file_dictionary;
						file_id = new_id;
						new_file_dictionary[new_id] = {
							file_name: file_name,
							version: 1,
							locked: false
						}
					}
				}else if(type == 'update'){
					if (!file_id) {
						return res.send({result: false, reason: "the request missed some data"});
					}			
					if(!file_dictionary[file_id]){
						remove_file(uploadedFile)
						return res.send({result: false, reason: "no such a file"})
					}else if (file_dictionary[file_id]['locked']) {
						remove_file(uploadedFile)
						return res.send({result: false, reason: "file locked"})
					}else{
						var new_file_dictionary = file_dictionary;
						new_file_dictionary[file_id]['version'] = new_file_dictionary[file_id]['version'] + 1;
						file_name = new_file_dictionary[file_id]['file_name'];
					}
				}else{
					remove_file(uploadedFile)
					return res.send({result: false, reason: "type should be 'update' or 'new'"})
				}
				fs.rename('./temp/'+uploadedFile.filename, './files/' + new_file_dictionary[file_id]['file_name'], (error)=>{
					remove_file(uploadedFile);
					if (error) {
						return res.send({result: false, reason: "error on changing location on the server", error:error})
					}else{
			    	fs.writeFile("./files/files.json", JSON.stringify(new_file_dictionary),()=>{
							send_websocket_event({
							    "event": "file_update",
							    "file_name": new_file_dictionary[file_id]['file_name'],
							    "downloadLink": baseAPI + '/download_a_file?file_id=' + file_id,
							    "fileVersion": new_file_dictionary[file_id]['version'],
							    "file_id": file_id
							})
			    		new_file_dictionary[file_id]['file_id'] = file_id;
			    		return res.send({result: true, file: new_file_dictionary[file_id]});
			    	})
					}
				})
			})
	})

	function send_websocket_event(data){
		wss.clients.forEach(function(client) {
      client.send(JSON.stringify(data));
    });
	}

	function remove_file(file){
		fs.unlink('./temp/'+file.filename, (err) => {return 0;})
	}

	router.get('/', function(req, res, next) {
	  res.render('index', { title: 'Benediction API' });
	});
	return router; 
};
