import React from "react";
import "../css/Login.css";

class Login extends React.Component {
  state = {
    email: "",
    password: ""
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
