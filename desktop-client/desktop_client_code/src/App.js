import React from "react";
import "./css/main.css";
import ClickableFileElement from "./components/ClickableFileElement";
import AppContainer from "./components/AppContainer";
import Logo from "./components/Logo";
import SideBarNav from "./components/SideBarNav";
import FileDirectory from "./components/FileDirectory";

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { selectedElement: activeDirectory("NOTHING") };

    // This binding is necessary to make `this` work in the callback
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.setState(state => ({
      selectedElement: "selectedMenu"
    }));
  }

  render() {
    return (
      //jsx
      <AppContainer>
        <div className="left-container">
          <Logo />
          <div className="nav-container">
            <div className="nav-container_list">
              <SideBarNav />
            </div>
          </div>
        </div>
        <div className="right-container">
          <FileDirectory />
          <div className="main-container">
            <div v-if="mode == 'Files'" className="files-container">
              <ClickableFileElement image="folder.png" title="Family Images" />
              <ClickableFileElement image="folder.png" title="School Project" />
              <ClickableFileElement image="folder.png" title="My Cats" />
              <ClickableFileElement image="folder.png" title="My Dogs" />
              <ClickableFileElement image="folder.png" title="Documents" />
              <ClickableFileElement image="folder.png" title="Work" />
              <ClickableFileElement image="folder.png" title="Videos" />
              <ClickableFileElement
                image="music_file.png"
                title="Whatever.mp3"
              />
            </div>
          </div>
        </div>
      </AppContainer>
    );
  }
}

const activeDirectory = selectedElement => {
  return selectedElement ? selectedElement : "null";
};
export default App;
