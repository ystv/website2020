import React from "react";
import "../stylesheets/navbar.css";
import ystv from "../assets/images/icons/ystv.svg";

type NavProps = {
  text: string;
  href: string;
  img: string;
};

const NavItem = ({ text, href, img }: NavProps) => {
  return (
    <li className="nav-item">
      <a className="nav-link" href={href}>
        <img src={img} alt={text} />
        <span>{text}</span>
      </a>
    </li>
  );
};

const Navbar = () => {
  return (
    <nav>
      <NavItem text="Home" href="/" img={ystv} />
      <NavItem text="Watch" href="/watch" img="" />
      <NavItem text="About" href="/about" img="" />
      <NavItem text="Teams" href="/teams" img="" />
      <NavItem text="Hires" href="/hires" img="" />
      <NavItem text="Calendar" href="/calendar" img="" />
      <NavItem text="Quotes" href="/quotes" img="" />
      <NavItem text="Inventory" href="/inventory" img="" />
      <NavItem text="Webcams" href="/webcams" img="" />
    </nav>
  );
};

export default Navbar;
