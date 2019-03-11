/*
Module:superagent
superagent is used to handle post/get requests to server
*/
import React from "react";

var request = require("superagent");
var apiBaseUrl = "http://52.151.113.157/upload_a_file";
class UploadFile extends React.Component {
  handleUpload(event) {
    console.log("handleUpload", event);
    var self = this;
    if (this.state.filesToBeSent.length > 0) {
      var filesArray = this.state.filesToBeSent;
      var req = request.post(apiBaseUrl + "fileupload");
      for (var i in filesArray) {
        console.log("files", filesArray[i][0]);
        req.attach(filesArray[i][0].name, filesArray[i][0]);
      }
      req.end(function(err, res) {
        if (err) {
          console.log("error ocurred");
        }
        console.log("res", res);
        alert("File printing completed");
      });
    } else {
      alert("Please upload some files first");
    }
  }
}

export default UploadFile;
