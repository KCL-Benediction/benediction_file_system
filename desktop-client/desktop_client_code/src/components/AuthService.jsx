import decode from "jwt-decode";

export default class AuthService {
  constructor(domain) {
    this.domain = domain || "http://52.151.113.157";
    this.fetch = this.fetch.bind(this);
    this.signup = this.signup.bind(this);
    this.login = this.login.bind(this);
    this.getProfile = this.getProfile.bind(this);
  }

  signup(username, password, firstname, lastname) {
    return this.fetch(`${this.domain}/users/register`, {
      method: "POST",
      body: JSON.stringify({
        username,
        password,
        firstname,
        lastname
      })
    })
      .then(res => {
        alert("You have successfully registered.");
      })
      .catch(err => {
        alert("Please input all details.");
      });
  }

  login(username, password) {
    var fs = window.require("fs");
    // Get a token from api server using the fetch api
    return this.fetch(`${this.domain}/users/login`, {
      method: "POST",
      body: JSON.stringify({
        username,
        password
      })
    }).then(res => {
      this.setToken(res.token);
      fs.writeFile("./public/codeFile.txt", this.getToken(), function(err) {
        if (err) {
          console.log(err);
        }
      });
      return Promise.resolve(res);
    });
  }

  loggedIn() {
    const token = this.getToken();
    return !!token && !this.isTokenExpired(token);
  }

  isTokenExpired(token) {
    try {
      const decoded = decode(token);
      if (decoded.exp < Date.now() / 1000) {
        return true;
      } else return false;
    } catch (err) {
      return false;
    }
  }

  setToken(idToken) {
    localStorage.setItem("id_token", idToken);
  }

  getToken() {
    return localStorage.getItem("id_token");
  }

  logout() {
    localStorage.removeItem("id_token");
  }

  getProfile() {
    // Using jwt-decode npm package to decode the token
    return decode(this.getToken());
  }

  fetch(url, options) {
    const headers = {
      Accept: "application/json",
      "Content-Type": "application/json"
    };

    // Authorization: Bearer xxxxxxx.xxxxxxxx.xxxxxx
    if (this.loggedIn()) {
      headers["Authorization"] = "Bearer " + this.getToken();
    }

    return fetch(url, {
      headers,
      ...options
    })
      .then(this.checkStatus)
      .then(response => response.json());
  }

  checkStatus(response) {
    if (response.status >= 200 && response.status < 300) {
      return response;
    } else {
      var error = new Error(response.statusText);
      error.response = response;
      throw error;
    }
  }
}
