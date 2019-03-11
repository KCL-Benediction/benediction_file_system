import React from "react";
import "../css/main.css";
import ClickableFileElement from "./../components/ClickableFileElement";
import UploadDrop from "./../components/UploadDrop";
import FilePage from "../pages/FilePage";

class File extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isClick: false
    };
  }

  triggerClickFile = () => {
    this.setState({
      ...this.state,
      isClick: true
    });
  };

  render() {
    return (
      <div className="main-container">
        <UploadDrop />

        <div className="files-container">
          <ClickableFileElement
            image="folder.png"
            title="Family Images"
            click={this.triggerClickFile}
          />
          <ClickableFileElement image="folder.png" title="School Project" />
          <ClickableFileElement image="folder.png" title="My Cats" />
          <ClickableFileElement image="folder.png" title="My Dogs" />
          <ClickableFileElement image="folder.png" title="Documents" />
          <ClickableFileElement image="folder.png" title="Work" />
          <ClickableFileElement image="folder.png" title="Videos" />
          <ClickableFileElement image="music_file.png" title="Whatever.mp3" />
        </div>
        {this.state.isClick && <FilePage />}
      </div>
    );
  }
}

export default File;
