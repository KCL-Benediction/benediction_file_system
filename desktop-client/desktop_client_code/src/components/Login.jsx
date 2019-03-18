import React from "react";
import "../css/Login.css";

class Login extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      username: "",
      password: ""
    };
  }

  handleChange = e => {
    this.setState({
      [e.target.id]: e.target.value
    });
  };
  handleSubmit = e => {
    e.preventDefault();
    console.log(this.state);
  };
  validateForm() {
    return this.username > 0 && this.password > 0;
  }

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
