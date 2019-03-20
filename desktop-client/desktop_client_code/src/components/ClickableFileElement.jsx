import React from "react";
import "../css/main.css";

class ClickableFileElement extends React.Component {
  render() {
    const { image, title, DoubleClick } = this.props;
    return (
      <div className="file" onDoubleClick={DoubleClick}>
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
