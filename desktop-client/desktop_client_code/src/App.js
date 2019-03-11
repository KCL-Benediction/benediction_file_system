import React from "react";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import "./css/main.css";
import AppContainer from "./components/AppContainer";
import Logo from "./components/Logo";
import SideBarNav from "./components/SideBarNav";
import FileDirectory from "./components/FileDirectory";
import Files from "./pages/Files";
import Setting from "./pages/Setting";
import Login from "./components/Login";
import Signup from "./components/Signup";

class App extends React.Component {
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
    return (
      <BrowserRouter>
        <Switch>
          <Route path="/Login" component={Login} />
          <Route path="/Signup" component={Signup} />
          <AppContainer>
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
          </AppContainer>
        </Switch>
      </BrowserRouter>
    );
  }
}

const activeDirectory = selectedElement => {
  return selectedElement ? selectedElement : "null";
};
export default App;
