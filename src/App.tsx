import React from 'react';
import logo from './ystv logo purple.png';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          New YSTV, coming soon...
        </p>
        <a
          className="App-link"
          href="https://ystv.co.uk"
          target="_blank"
          rel="noopener noreferrer"
        >
          Visit the old website
        </a>
      </header>
    </div>
  );
}

export default App;
