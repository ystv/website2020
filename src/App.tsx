import React, { useState, Suspense, useEffect, useReducer } from "react";
import "./App.css";
import Navbar from "./components/navbar";
import Main from "./components/main";

function App() {
  return (
    <div className="App">
      <Navbar />
      <Suspense fallback={<div>Loading...</div>}>
        <Main />
      </Suspense>
    </div>
  );
}

export default App;
