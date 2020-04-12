import React, { useState, JSXElementConstructor } from "react";
import "../stylesheets/navbar.css";
import ystv from "../assets/images/icons/ystv colour.png";
import { IosSearch } from "@simonmeusel/react-ionicons/IosSearch";
import { IosFilm } from "@simonmeusel/react-ionicons/IosFilm";
import { IosBriefcase } from "@simonmeusel/react-ionicons/IosBriefcase";
import { IosCalendar } from "@simonmeusel/react-ionicons/IosCalendar";
import { IosInformationCircleOutline } from "@simonmeusel/react-ionicons/IosInformationCircleOutline";

const menuItems = ["Watch", "Freshers", "Hires", "Calendar", "About"];

const menuLogos = [
  IosFilm(),
  IosFilm(),
  IosBriefcase(),
  IosCalendar(),
  IosInformationCircleOutline(),
];

const menuColours = ["#E00", "orange", "#DD0", "green", "#00D"];

const purpleColour = "rgb(95, 61, 127)";

const LoginButton = () => {
  return (
    <NavItem
      text="Login"
      href="https://sso.ystv.co.uk"
      img="people"
      id={-1}
      colour={purpleColour}
    />
  );
};
function ProfileButton(name: string) {
  return (
    <NavItem
      text={name}
      href="https://sso.ystv.co.uk/profile"
      img="person"
      id={-1}
      colour={purpleColour}
    />
  );
}

function ProfileLoginButton() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  var returner;
  if (isLoggedIn === false) {
    returner = LoginButton();
  } else {
    returner = ProfileButton("Testy Testerson");
  }
  return returner;
}

type NavProps = {
  text: string;
  href: string;
  img: string;
  id: number;
  colour: string;
};

const NavItem = ({ text, href, img, id, colour }: NavProps) => {
  var PictItem;
  if (id == -1) {
    const icon = require("../assets/images/icons/navbar/" + img + ".svg");
    PictItem = (
      <a
        className="nav-link"
        href={href}
        style={{ color: colour, fill: colour }}
      >
        <img
          src={icon}
          alt={text}
          className="nav-item-logo"
          style={{
            filter:
              "invert(.55) sepia(1) saturate(20) hue-rotate(226.8deg) brightness(.5)",
          }}
        />
        <span>{text}</span>
      </a>
    );
  } else {
    PictItem = (
      <a
        className="nav-link"
        href={href}
        style={{ color: menuColours[id], fill: menuColours[id] }}
      >
        {menuLogos[id]} <span>{text}</span>
      </a>
    );
  }
  return <li className="nav-item active neumorph">{PictItem}</li>;
};

function Navbar() {
  return (
    <nav className="navbar navbar-expand-lg sticky-top">
      <a className="navbar-brand ml-5" href="">
        <img src={ystv} height="40" alt="YSTV" className="shadowed" />
      </a>

      <button
        className="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span className="navbar-toggler-icon"></span>
      </button>

      <div className="collapse navbar-collapse" id="navbarSupportedContent">
        <form className="form-inline my-2 my-lg-0 neumorph neumorph-in">
          <input
            className="form-control mr-sm-2"
            type="search"
            placeholder="Search our videos"
            aria-label="Search"
          />
          <button className="btn my-2 my-sm-0" type="submit">
            <div className="nav-item-logo">
              <IosSearch />
            </div>
          </button>
        </form>
        <ul className="navbar-nav ml-auto mr-5">
          {menuItems.map(function (e, i) {
            return (
              <NavItem
                text={e}
                href={"/" + e.toLowerCase()}
                img={e.toLowerCase()}
                id={i}
                key={i}
                colour=""
              />
            );
          })}
          <ProfileLoginButton />
        </ul>
      </div>
    </nav>
  );
}

export default Navbar;
