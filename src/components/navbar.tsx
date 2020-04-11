import React, { useState, JSXElementConstructor } from "react";
import "../stylesheets/navbar.css";
import ystv from "../assets/images/icons/ystv.svg";

const menuItems = ["Watch", "Freshers", "Hires", "Calendar", "About"];

const LoginButton = () => {
  return <NavItem text="Login" href="https://sso.ystv.co.uk" img=""></NavItem>;
};
function ProfileButton(name: string) {
  return (
    <NavItem text={name} href="https://sso.ystv.co.uk/profile" img=""></NavItem>
  );
}

function ProfileLoginButton() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  var returner;
  if (isLoggedIn === false) {
    return <LoginButton />;
  } else {
    return ProfileButton("Testy Testerson");
  }
}

type NavProps = {
  text: string;
  href: string;
  img: string;
};

const NavItem = ({ text, href, img }: NavProps) => {
  return (
    <li className="nav-item">
      <a className="nav-link" href={href}>
        <img src={"../assets/images/icons/navbar" + img + ".svg"} alt={text} />
        <span>{text}</span>
      </a>
    </li>
  );
};

const Navbar = () => {
  return (
    <nav>
      <li className="nav-item">
        <a className="nav-link" href="/">
          <img src={ystv} alt="YSTV" />
        </a>
      </li>
      Search Live api-special
      {menuItems.map(function (e, i) {
        return <NavItem text={e} href={"/" + e.toLowerCase()} img="" key={i} />;
      })}
      Internal
      <ProfileLoginButton />
    </nav>
  );
};

export default Navbar;
