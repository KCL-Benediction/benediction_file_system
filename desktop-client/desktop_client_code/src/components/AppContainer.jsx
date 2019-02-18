import React from "react";
import "../css/main.css";

class AppContainer extends React.Component {
  render() {
    //const { children } = this.props;
    return (
      <div className="whole-container" id="app">
        {this.props.children}
      </div>
    );
  }
}
export default AppContainer;
