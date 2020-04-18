import React, { useState, JSXElementConstructor } from "react";
import "../stylesheets/navbar.css";
import ystv from "../assets/images/icons/ystv colour.png";
import { IosSearch } from "@simonmeusel/react-ionicons/IosSearch";
import Navbar from "react-bootstrap/Navbar";
import Nav from "react-bootstrap/Nav";
import {
  IoIosListBox,
  IoIosFilm,
  IoIosGlobe,
  IoIosBriefcase,
  IoIosCalendar,
  IoIosInformationCircleOutline,
} from "react-icons/io";

const menuItems = ["Watch", "Freshers", "Hires", "Calendar", "About"];

const menuLogos = [
  IoIosFilm({}),
  IoIosGlobe({}),
  IoIosBriefcase({}),
  IoIosCalendar({}),
  IoIosInformationCircleOutline({}),
  IoIosListBox({}),
];

const menuColours = ["#E00", "#ff8b20", "#f3b800", "green", "#00a1ff", "#00D"];

const purpleColour = "rgb(95, 61, 127)";

type NavProps = {
  text: string;
  href: string;
  img: string;
  id: number;
  colour: string;
};

const NavItem = ({ text, href, img, id, colour }: NavProps) => {
  var PictItem;
  if (id === -1) {
    const icon = require("../assets/images/icons/navbar/" + img + ".svg");
    PictItem = (
      <Nav.Link href={href} style={{ color: colour, fill: colour }}>
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
      </Nav.Link>
    );
  } else {
    PictItem = (
      <Nav.Link
        className="nav-link"
        href={href}
        style={{ color: menuColours[id], fill: menuColours[id] }}
      >
        {menuLogos[id]} <span>{text}</span>
      </Nav.Link>
    );
  }
  return <li className="nav-item active neumorph">{PictItem}</li>;
};

function NavbarElem() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);

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

  const InternalButton = () => {
    const e = "Internal";
    const i = menuItems.length;
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

  return (
    <Navbar collapseOnSelect expand="lg" bg="light" variant="light">
      <Navbar.Brand href="/" style={{ paddingLeft: "2rem" }}>
        <img src={ystv} height="40" alt="YSTV" className="shadowed" />
      </Navbar.Brand>
      <Navbar.Toggle aria-controls="responsive-navbar-nav" />
      <Navbar.Collapse
        id="responsive-navbar-nav"
        style={{ paddingLeft: "2rem", paddingRight: "2rem" }}
      >
        <Nav className="mr-auto container-md">
          <form className="form-inline my-2 my-lg-0 neumorph neumorph-in container-sm">
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
        </Nav>
        {
          ///////// INSERT SPECIAL BUTTON AND LIVE BUTTON
        }
        <Nav>
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
          {isLoggedIn == true && InternalButton()}
          {isLoggedIn == true
            ? ProfileButton("Testy Testerson")
            : LoginButton()}
        </Nav>
      </Navbar.Collapse>
    </Navbar>
  );
}

export default NavbarElem;
