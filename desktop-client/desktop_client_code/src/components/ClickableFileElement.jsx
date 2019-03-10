import React from "react";
import "../css/main.css";

class ClickableFileElement extends React.Component {
  render() {
    const { image, title, click } = this.props;
    return (
      <div className="file" onClick={click}>
        <img
          src={require("../images/" + image)}
          className="file_image"
          alt="fileImage"
        />
        <p>{title}</p>
      </div>
    );
  }
}

export default ClickableFileElement;
