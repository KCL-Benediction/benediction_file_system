import React from "react";
import "../css/main.css";
import Main from "../js/Main.js";

class SideBarNav extends React.Component {
  render() {
    return (
      <React.Fragment>
        <div className="nav-container_list_button">
          <i className="far fa-file nav-container_list_button_icon" />
          <Main mode="Files" />
        </div>
        <div className="nav-container_list_button">
          <i className="fas fa-sliders-h nav-container_list_button_icon" />
          <Main mode="Settings" />
        </div>
      </React.Fragment>
    );
  }
}

export default SideBarNav;
