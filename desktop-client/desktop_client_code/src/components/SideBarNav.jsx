import React from "react";
import "../css/main.css";
import Main from "../js/Main.js";
import { withRouter } from "react-router-dom";
import AuthService from "./AuthService";
const Auth = new AuthService();

class SideBarNav extends React.Component {
  handleLogout() {
    Auth.logout();
    this.props.history.replace("/login");
  }
  render() {
    return (
      <React.Fragment>
        <div
          className="nav-container_list_button"
          onClick={() => this.props.changePage("files")}
        >
          <i className="far fa-file nav-container_list_button_icon" />
          <Main mode="Files" />
        </div>
        <div
          className="nav-container_list_button"
          onClick={() => this.props.changePage("setting")}
        >
          <i className="fas fa-cog nav-container_list_button_icon " />
          <Main mode="Settings" />
        </div>
        <div
          className="nav-container_list_button"
          onClick={this.handleLogout.bind(this)}
        >
          <i className="fas fa-sign-out-alt nav-container_list_button_icon" />
          <Main mode="Logout" />
        </div>
      </React.Fragment>
    );
  }
}

export default withRouter(SideBarNav);
