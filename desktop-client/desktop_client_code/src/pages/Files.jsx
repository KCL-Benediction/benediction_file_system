import React from "react";
import "../css/main.css";
import ClickableFileElement from "./../components/ClickableFileElement";

class File extends React.Component {
  render() {
    return (
      <div className="main-container">
        <div className="files-container">
          <ClickableFileElement image="folder.png" title="Family Images" />
          <ClickableFileElement image="folder.png" title="School Project" />
          <ClickableFileElement image="folder.png" title="My Cats" />
          <ClickableFileElement image="folder.png" title="My Dogs" />
          <ClickableFileElement image="folder.png" title="Documents" />
          <ClickableFileElement image="folder.png" title="Work" />
          <ClickableFileElement image="folder.png" title="Videos" />
          <ClickableFileElement
            image="music_file.png"
            title="Whatever.mp3"
          />
        </div>
      </div>
    );
  }
}

export default File;
