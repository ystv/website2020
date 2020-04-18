import React, { Suspense } from "react";
import "./App.css";
import Navbar from "./components/navbar";
import jquery from "jquery";
import "bootstrap/dist/css/bootstrap.min.css";
const Main = React.lazy(() => import("./components/main"));

function App() {
  return (
    <div className="App">
      <Navbar />
      <Suspense
        fallback={
          <div
            className="d-flex justify-content-center"
            style={{ height: "93vh" }}
          >
            <div className="spinner-border" role="status">
              <span className="sr-only">Loading...</span>
            </div>
          </div>
        }
      >
        <Main />
      </Suspense>
      <link
        rel="stylesheet"
        href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
        integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
        crossOrigin="anonymous"
      />
    </div>
  );
}

export default App;
