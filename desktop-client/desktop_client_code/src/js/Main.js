import React from "react";

class Main extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      mode: "Files"
    };

    //binding to make 'this' work in the callback
    this.FileDirName = this.FileDirName.bind(this);
  }

  FileDirName() {
    this.setState(state => ({ mode: state.mode }));
    console.log("The button was clicked");
  }

  render() {
    const { mode } = this.props;
    return (
      <React.Fragment>
        <p
          className="nav-container_list_button_text"
          onClick={this.FileDirName}
        >
          {mode}
        </p>
      </React.Fragment>
    );
  }
}
export default Main;
