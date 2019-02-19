import React from "react";
import "../css/main.css";

class Logo extends React.Component {
  render() {
    return (
      <div className="logo-container">
        <div className="logo-container_logo-container">
          <img
            className="logo-container_logo-container_image"
            src={require("../images/logo.png")}
            alt="logoImage"
          />
        </div>
        <div className="logo-container_name-container">
          <p className="logo-container_name-container_name">Benediction</p>
        </div>
      </div>
    );
  }
}
export default Logo;
