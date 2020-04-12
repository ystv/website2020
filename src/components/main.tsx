import React from "react";
import "../stylesheets/main.css";
import SimpleBar from "simplebar-react";
import "simplebar/dist/simplebar.min.css";

function Main() {
  return (
    <SimpleBar style={{ maxHeight: "100%" }}>
      <img
        src="https://static.photocdn.pt/images/articles/2019/10/02/Simple_Landscape_Photography_Tips_With_Tons_of_Impact.jpg"
        alt=""
        height="500px"
      />
    </SimpleBar>
  );
}

export default Main;
