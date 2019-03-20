import React from "react";
import "../css/main.css";
import Logo from "./Logo";
import SideBarNav from "./SideBarNav";
import FileDirectory from "./FileDirectory";
import Files from "../pages/Files";
import Setting from "../pages/Setting";
import WithAuth from "./WithAuth";

class AppContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedElement: activeDirectory("NOTHING"),
      onPage: "files"
    };
  }

  handleClick = () => {
    this.setState(state => ({
      selectedElement: "selectedMenu"
    }));
  };

  changePage = page => {
    this.setState({
      onPage: page
    });
  };

  renderTitleString = () => {
    if (this.state.onPage === "files") {
      return "Files";
    } else if (this.state.onPage === "setting") {
      return "Settings";
    }
  };

  renderMainPage = () => {
    if (this.state.onPage === "files") {
      return <Files />;
    } else if (this.state.onPage === "setting") {
      return <Setting />;
    }
  };

  render() {
    //const { children } = this.props;
    return (
      <div className="whole-container" id="app">
        <div className="left-container">
          <Logo />
          <div className="nav-container">
            <div className="nav-container_list">
              <SideBarNav changePage={this.changePage} />
            </div>
          </div>
        </div>
        <div className="right-container">
          <FileDirectory title={this.renderTitleString()} />
          {this.renderMainPage()}
        </div>
      </div>
    );
  }
}
const activeDirectory = selectedElement => {
  return selectedElement ? selectedElement : "null";
};
export default WithAuth(AppContainer);
