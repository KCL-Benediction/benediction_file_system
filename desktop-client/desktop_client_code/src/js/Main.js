import React from "react";

class Main extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      mode: "Files"
    };

    //binding to make 'this' work in the callback
    this.FileDirName = this.FileDirName.bind(this);
  }

  FileDirName() {
    this.setState(state => ({ mode: state.mode }));
    console.log("The button was clicked");
  }

  render() {
    const { mode } = this.props;
    return (
      <React.Fragment>
        <p
          className="nav-container_list_button_text"
          onClick={this.FileDirName}
        >
          {mode}
        </p>
      </React.Fragment>
    );
  }
}
var folderWatch = require("./modules/DirectoryWatcher.js");

var fileMonitor = new folderWatch.DirectoryWatcher("C:\\benedictionFiles", true);

// start the monitor and have it check for updates
// every half second.
fileMonitor.start(500);

// log to the console when a file is added.
fileMonitor.on("fileAdded", function (fileDetail) {
  console.log("File Added: " + fileDetail.fullPath);
});

// Log to the console when a file is changed.
fileMonitor.on("fileChanged", function (fileDetail, changes) {
  console.log("File Changed: " + fileDetail.fullPath);
  for (var key in changes) {
    console.log("  + " + key + " changed...");
    console.log("    - From: " + ((changes[key].baseValue instanceof Date) ? changes[key].baseValue.toISOString() : changes[key].baseValue));
    console.log("    - To  : " + ((changes[key].comparedValue instanceof Date) ? changes[key].comparedValue.toISOString() : changes[key].comparedValue));
  }
});

// Log to the console when a file is removed
fileMonitor.on("fileRemoved", function (filePath) {
  console.log("File Deleted: " + filePath);
});

// Let us know that directory monitoring is happening and where.
console.log("Directory Monitoring of " + fileMonitor.root + " has started");
  

export default Main;
