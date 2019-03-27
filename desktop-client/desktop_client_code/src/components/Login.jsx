import React from "react";
import "../css/Login.css";
import AuthService from "./AuthService";

class Login extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.Auth = new AuthService();
  }

  handleChange = e => {
    this.setState({
      [e.target.id]: e.target.value
    });
  };

  handleSubmit = e => {
    e.preventDefault();

    if (!!this.state && !!(this.state.username && this.state.password)) {
      this.Auth.login(this.state.username, this.state.password).then(res => {
        this.props.history.replace("/");
      });
    } else {
      e.preventDefault(alert("Please enter your username and password."));
    }
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
            <button className="LoginButton">Login</button>
          </div>
          <h2>
            <a href="./Signup">Create an Account</a>
          </h2>
        </form>
      </div>
    );
  }
}

export default Login;
