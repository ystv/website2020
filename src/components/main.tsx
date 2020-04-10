import React from "react";
import logo from "../ystv logo purple.png";

const Main = () => {
  return (
    <main className="App-header">
      <img src={logo} className="App-logo" alt="logo" />
      <p>New YSTV, coming soon...</p>
      <a
        className="App-link"
        href="https://ystv.co.uk"
        target="_blank"
        rel="noopener noreferrer"
      >
        Visit the current website
      </a>
    </main>
  );
};

export default Main;
