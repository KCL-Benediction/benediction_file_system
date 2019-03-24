import React from "react";
import "../css/Login.css";
import "../css/main.css";
import AuthService from "./AuthService";

class Signup extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.Auth = new AuthService();
  }

  handleChange = e => {
    this.setState({
      [e.target.id]: e.target.value
    });
  };
  handleSubmit = e => {
    //e.preventDefault();

    if (
      !!this.state &&
      !!(
        this.state.username &&
        this.state.password &&
        this.state.firstname &&
        this.state.lastname
      )
    ) {
      this.Auth.signup(
        this.state.username,
        this.state.password,
        this.state.firstname,
        this.state.lastname
      ).then(res => {
        this.props.history.replace("/login");
      });
    } else {
      e.preventDefault(alert("Please enter all details."));
    }
  };

  handleBackClick = e => {
    e.preventDefault();
    this.props.history.replace("/login");
  };

  render() {
    return (
      <div className="LoginContainer">
        <form onSubmit={this.handleSubmit} className="form">
          <button className="backBTN" onClick={this.handleBackClick}>
            <i className="fas fa-long-arrow-alt-left" />
          </button>
          <span>
            <img
              src={require("../images/logo.png")}
              className="logoLogin"
              alt="LogoLogin"
            />
          </span>
          <div className="inputField">
            <input
              type="username"
              id="username"
              onChange={this.handleChange}
              placeholder="Username"
            />
          </div>
          <div className="inputField">
            <input
              type="password"
              id="password"
              onChange={this.handleChange}
              placeholder="Password"
            />
          </div>

          <div className="inputField">
            <input
              type="text"
              id="firstName"
              onChange={this.handleChange}
              placeholder="First Name"
            />
          </div>
          <div className="inputField">
            <input
              type="text"
              id="lastName"
              onChange={this.handleChange}
              placeholder="Last Name"
            />
          </div>
          <div className="inputField">
            <button className="LoginButton">Sign Up</button>
          </div>
        </form>
      </div>
    );
  }
}

export default Signup;
