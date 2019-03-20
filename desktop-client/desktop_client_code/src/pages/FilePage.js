import React from "react";
import "../css/main.css";
import UploadDrop from "./../components/UploadDrop";
import Files from "../pages/Files";

class FilePage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isClick: false
    };
  }

  triggerBackButton = () => {
    this.setState({
      ...this.state,
      isClick: true
    });
  };

  renderPage = () => {
    if (this.state.isClick === false) {
      return (
        <div className="filePage">
          <p>This is file page</p>
          <UploadDrop />
          <button className="backButton" onClick={this.triggerBackButton}>
            Back
          </button>
        </div>
      );
    } else {
      return <Files />;
    }
  };

  render() {
    return <div className="main-container">{this.renderPage()}</div>;
  }
}

export default FilePage;
