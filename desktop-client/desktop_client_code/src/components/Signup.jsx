import React from "react";
import "../css/Login.css";

class Signup extends React.Component {
  state = {
    email: "",
    password: "",
    firstName: "",
    lastName: ""
  };
  handleChange = e => {
    this.setState({
      [e.target.id]: e.target.value
    });
  };
  handleSubmit = e => {
    e.preventDefault();
    console.log(this.state);
  };

  render() {
    return (
      <div className="LoginContainer">
        <form onSubmit={this.handleSubmit} className="form">
          <span>
            <img
              src={require("../images/logo.png")}
              className="logoLogin"
              alt="LogoLogin"
            />
          </span>
          <div className="inputField">
            <input
              type="email"
              id="email"
              onChange={this.handleChange}
              placeholder="Email"
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
