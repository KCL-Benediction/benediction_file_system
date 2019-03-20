import React from "react";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import "./css/main.css";
import AppContainer from "./components/AppContainer";
import Login from "./components/Login";
import Signup from "./components/Signup";

class App extends React.Component {
  render() {
    return (
      <BrowserRouter>
        <Switch>
          <Route exact path="/Login" component={Login} />
          <Route exact path="/Signup" component={Signup} />
          <Route exact path="/" component={AppContainer} />
        </Switch>
      </BrowserRouter>
    );
  }
}

export default App;
