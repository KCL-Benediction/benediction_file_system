import React from "react";
import "../css/main.css";
// import ClickableFileElement from "./../components/ClickableFileElement";
import UploadDrop from "./../components/UploadDrop";
import GetServerData from "../components/GetServerData";

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
        <div className="files-container">
          <GetServerData />
          <UploadDrop />
        </div>
      </div>
    );
  }
}

export default File;
