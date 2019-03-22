//require('./src/FsWatcher.js') 
/*
 ===========================================================================
 Benediction Module handling local folder to server synchronisation

 Monitor local folder using the DirectoryWatcher object using the below events

 fileAdded        : Addition of a new file to the local directory folder
 fileRemoved      : Removal of file from local directory folder
 fileChanged      : CHanging existing local directory file
 scannedDirectory : When a directory has been scanned

 Events trigger call to server API ti perform relevant synchronisation with server directory
===========================================================================
*/
// Imports / Requires
var fs = require("fs"),
  path = require("path"),
  req = require('request'),
  fileAgent = require('superagent'),
  fetch = require('node-fetch'),
  util = require("util"),
  events = require("events");

/*
  A FileDetail Object stores the following details about a file
  - directory, fullPath, fileName, size, extension, 
    accessed, modified, created 
*/
var FileDetail = function (directory, fullPath, fileName, size, extension, accessed, modified, created) {
  this.directory = directory;
  this.fullPath = fullPath;
  this.fileName = fileName;
  this.extension = extension;
  this.size = size;
  this.accessed = accessed;
  this.modified = modified;
  this.created = created;
};

// FileDetailComparisonResults holds FileDetail comparison reseults
var FileDetailComparisonResults = function () {
  this.different = false;
  this.differences = {};
};

// Comparison method to detect changes between
// this and a passed in FileDetail object
FileDetail.prototype.compareTo = function (fd) {
  var self = this,
    base,
    compare,
    results = new FileDetailComparisonResults();
  // loop through FileDetail properties
  for (var key in self) {
    if (self[key] instanceof Date) {
      base = self[key].toISOString();
      compare = fd[key].toISOString();
    } else {
      base = self[key];
      compare = fd[key];
    }
    if (base !== compare) {
      // Create the differences node if it doesn't exist
      if (!results.differences[key]) {
        results.differences[key] = {};
      }
      // record the differences
      results.differences[key].baseValue = self[key];
      results.differences[key].comparedValue = fd[key];
      // Mark the resulting FileDetailComparisonResults object as different.
      results.different = true;
    }
  }
  // return the results
  return results;
};

// Object watching the benediction local directory for file changes
var DirectoryWatcher = function (root, recursive) {
  this.root = root;  // Root or base directory
  this.recursive = recursive;  // recursively monitor sub-folders?
  this.directoryStructure = {};  // object holding representation of directory structure
  this.timer = null;  // timer handling scan passes
  this.suppressInitialEvents = true;  // should we supress initial events?

  // set a self var
  var self = this;

  // Call the EventEmitter
  events.EventEmitter.call(this);


  // Gets the parent node of the last folder in the path
  // given and calls selectCurrentNode 
  var selectParentNode = function (dir, suppressEvents) {
    var hierarchy = dir.split(path.sep);
    var newPath = "";
    hierarchy.pop();
    newPath = hierarchy.join(path.sep);
    return (selectCurrentNode(newPath, suppressEvents));
  };

  // Get the node represented by the local directory path passed in
  // from the directoryStructure object. 
  // if the path/ isn't found - it will be added to the directoryStructure
  var selectCurrentNode = function (dir, suppressEvents) {
    var deepRoot = self.root.replace(path.basename(self.root), "");
    // create an array representing the folder hierarchy.  
    var hierarchy = dir.replace(self.root, path.basename(self.root)).split(path.sep);
    var currentNode = self.directoryStructure;
    var currentPath = deepRoot;
    // loop through the hierarchy array
    for (var i = 0; i < hierarchy.length; i++) {
      currentPath += hierarchy[i] + path.sep;
      // if the node (folder) doesn't exist create it.
      if (currentNode[hierarchy[i]] == null) {
        currentNode[hierarchy[i]] = {};
        if (!suppressEvents) {
          self.emit("folderAdded", currentPath.substring(0, currentPath.length - 1));
        }
      }
      // set the currentNode to the latest one
      currentNode = currentNode[hierarchy[i]];
    }
    // return the most current node.
    return currentNode;
  };

  // Record any file into the directoryStructure 
  var recordFile = function (pathToFile, suppressEvents, callback) {
    // get the stats for the passed in file or folder
    fs.stat(pathToFile, function (err, stats) {
      // throw any return errors.
      if (err) throw err;
      // if it's a file, create the FileDetail Object
      if (stats.isFile()) {
        // get the folder only portion of the passed in file
        var dir = path.dirname(pathToFile);
        var fd = new FileDetail(
          dir,
          pathToFile,
          path.basename(pathToFile),
          stats.size,
          path.extname(pathToFile),
          stats.atime,
          stats.mtime,
          stats.ctime
        );
        // get appropriate node of the directoryStructure
        var currentNode = selectCurrentNode(dir, suppressEvents);
        // if the file already exists in the directoryStructure
        if (currentNode[fd.fileName]) {
          // detect if changed by comparing it.
          var fileCompare = currentNode[fd.fileName].compareTo(fd);
          if (fileCompare.different) {
            // if it's different then overwrite with new file
            currentNode[fd.fileName] = fd;
            if (!suppressEvents) {
              // emit the changes
              self.emit("fileChanged", fd, fileCompare.differences);
            }
          }
        } else {
          // Add - if the file isn't already stored in the directoryStructure
          currentNode[fd.fileName] = fd;
          if (!suppressEvents) {
            // emit that file has been added.
            self.emit("fileAdded", fd);
          }
        }
      } else if (stats.isDirectory()) {
        // if it's a directory and we're recursive
        // scan the passed in directory.
        if (self.recursive) {
          self.scanDirectory(pathToFile, suppressEvents);
        }
      }
      // fire off the callback function
      callback();
    });
  };

  // detectFileDelete detect if a file has been deleted from the local folder.
  var detectFileDelete = function (fd, suppressEvents) {
    fs.exists(fd.fullPath, function (exists) {
      if (!exists) {
        if (!suppressEvents) {
          self.emit("fileRemoved", fd.fullPath);
        }
        // remove the file if it no longer exists.
        var currentNode = selectCurrentNode(fd.directory, suppressEvents);
        delete currentNode[fd.fileName];
      }
    });
  };

  /* 
    detectDeletes detects deletions in the local directory,
    routes file deletes to its handler method
  */
  var detectDeletes = function (dir, suppressEvents) {
    var currentNode = selectCurrentNode(dir, suppressEvents);
    // loop through the filesin the current node
    for (var key in currentNode) {
      if (currentNode[key] instanceof FileDetail) {
        // route the the file delete detector
        detectFileDelete(currentNode[key], suppressEvents);
      } else {
        // detectFolderDelete(dir + path.sep + key, key, suppressEvents);
      }
    }
  };


  // scanDirectory scans a given directory and attempts
  // to record each file in the directory.
  this.scanDirectory = function (dir, suppressEvents) {
    fs.readdir(dir, function (err, files) {
      // throw any errors that came up
      if (err) throw err;
      var i = files.length;
      if (i === 0) {
        if (!suppressEvents) {
          self.emit("scannedDirectory", dir);
        }
      } else {
        // if files and folders loop through them.
        // reduce the count (i) after each callback so
        // we can know when to raise the scannedDirectory
        // event
        for (var f in files) {
          // Record the file
          // eslint-disable-next-line
          recordFile(path.join(dir, files[f]), suppressEvents, function () {
            i--;
            if (i === 0) {
              if (!suppressEvents) {
                self.emit("scannedDirectory", dir);
              }
            }
          });
        }
      }
      // Detect any folder or file deletes
      detectDeletes(dir, suppressEvents);
    });
  };

  // This starts the instance of the DirectoryWatcher monitoring
  this.start = function (interval) {
    if (interval) {
      self.timer = setInterval(function () { self.scanDirectory(self.root, false) }, interval);
    } else {
      // else stop monitoring
      self.stop();
    }
    // Initial scan of the directory... suppresses events for the first
    // scan through. The next scan will be after interval
    //can be used to sync the initial files found in the directory 
    self.scanDirectory(self.root, self.suppressInitialEvents);
    //get all files in the directory at start up
    fs.readdir(self.root, (err, files) => {
      files.forEach(file => {
        //console.log(file);
      });
    });
  };
  this.stop = function () {
    clearTimeout(self.timer);
  };

};
util.inherits(DirectoryWatcher, events.EventEmitter);

/* 
  fileMonitor watches local benediction App directory for any
  changes to files and performs relevant synchronisation with 
  server directory using fileAdded,  fileChanged and fileRemoved events
 */
var fileMonitor = new DirectoryWatcher("./benedictionFiles", true);
fileMonitor.start(500);

// sync local newly added file with server folder.
fileMonitor.on("fileAdded", function (fileDetail) {
  console.log("File: ", fileDetail.fileName, " has been Added.");
  
  ;
  fs.readFile("./public/codeFile.txt", 'utf-8', (error, content)=>{
    var code = 'Bearer '+content;

  //upload new file to server folder 
  fileAgent.post('http://52.151.113.157/upload_a_file')
  .set({ 'Authorization': code, Accept: 'application/json' }) 
  .field('type', 'new')
    .field('file_name', fileDetail.fileName)
    .attach('file', fileDetail.fullPath)
    .then(function (error, response, body) {
      fs.readFile("./public/files.json", 'utf-8', (error, content)=>{
        var obj = JSON.parse(content);
        obj[response.body.file.file_id] = response.body.file
        fs.writeFile("./public/files.json",JSON.stringify(obj),(error, dataWritten)=>{
            console.log(dataWritten)
        })
      });
      console.log('Error :', error);
      console.log('statusCode:', response && response.statusCode);
      console.log('body:', body);
      console.log('Addition of new file: ', fileDetail.fileName, ' has been synced with server');
    });
});
});
// sync with server if file has been changed.
fileMonitor.on("fileChanged", function (fileDetail, changes) {
  console.log("File: ", fileDetail.fileName, " has been changed.");

  fetch('http://52.151.113.157/get_all_file_details')
    .then(res => res.json())
    .then(json => {
      var data = json.files;
      for (var i = 0; i < data.length; i++) {
        if (data[i].file_name === fileDetail.fileName) {
          var fileId = data[i].file_id;
          fileAgent.post('http://52.151.113.157/upload_a_file')
            .field('file_id', fileId)
            .field('type', 'update')
            .attach('file', fileDetail.fullPath)
            .then(function (error, response, body) {
              console.log('Error :', error);
              console.log('statusCode:', response && response.statusCode);
              console.log('body:', body);
              console.log('File changes to: ', fileDetail.fileName, ' has been synced with server');
              if(error){
                warn('The file is locked and being used by another user, \nplease wait to download the latest version before uploading your changes!',
                'Benediction Sync-Lock Error');
                //alert('The file is locked and being used by another user, \nplease wait to download the latest version before uploading your changes!');
              }
            });
        }
      }
    });

});

// sync with server when file is removed from local folder
fileMonitor.on("fileRemoved", function (filePath) {
  console.log("File: ", filePath, " has been Deleted.");
  var fileDeleted = path.basename(filePath);
  //delete file from server if deleted from local monitored directory
  //checks whether the file exists on the server first before 
  //before calling the delete API end-point
  fetch('http://52.151.113.157/get_all_file_details')
    .then(res => res.json())
    .then(json => {
      var data = json.files;
      for (var i = 0; i < data.length; i++) {
        if (data[i].file_name === fileDeleted) {
          var fileId = data[i].file_id;
          fileAgent.post('http://52.151.113.157/delete_a_file')
            .field('file_id', fileId)
            .then(function (error, response, body) {
              console.log('Error :', error);
              console.log('statusCode:', response && response.statusCode);
              console.log('body:', body);
              console.log('Deletion of file: ', fileDeleted, ' has been synced with server');
            });
        }
      }
    });
});

// Local root directory monitoring and synchronising with server.
console.log("Local Folder synchronisation and monitoring of ", fileMonitor.root, " has started");
