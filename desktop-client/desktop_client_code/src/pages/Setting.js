import React from "react";
import "../css/main.css";

class Setting extends React.Component {
  render() {
    return (
      <div className="main-container">
        <div className="files-container">
          <div className="settingCont">
            <p>Double-clicked on a file to download it. </p>
            <p>
              The downloaded files will be stored in 'benedictionFiles' folder.
            </p>
            <p>
              Upload the files either by drag and drop to the UI or to the
              benedictionFiles' folder.
            </p>
          </div>
        </div>
      </div>
    );
  }
}

export default Setting;
