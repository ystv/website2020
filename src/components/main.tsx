import React, { Suspense, useState } from "react";
import "../stylesheets/main.css";
import SimpleBar from "simplebar-react";
import "simplebar/dist/simplebar.min.css";
import testdata from "../testdata.json";
import VideoPlayer from "./VideoJsPlayer";

type VideoContainerType = {
  title: string;
  link: string;
  image: string;
};

function VideoContainer(
  { title, link, image }: VideoContainerType,
  key: number
) {
  return (
    <a href={link}>
      <div
        className="card neumorph neumorph-card col-"
        style={{ height: "16rem", width: "18rem" }}
      >
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
          <img src={image} className="card-img-top thumb" alt="..." />
        </Suspense>
        <div className="card-body">
          <p className="card-text caption-overflow">{title}</p>
        </div>
      </div>
    </a>
  );
}

const videoJsOptions = {
  autoplay: false,
  controls: true,
  liveui: false,
  sources: [
    {
      src: "https://ystv.co.uk/videostream/18053",
      type: "video/mp4",
      label: "1080p",
      res: "1080",
    },
    {
      src: "https://ystv.co.uk/videostream/18051",
      type: "video/mp4",
      label: "720p",
      res: "720",
    },
    {
      src: "https://ystv.co.uk/videostream/18048",
      type: "video/mp4",
      label: "SD",
      res: "360",
    },
  ],
  preload: "auto",
  poster: "https://ystv.co.uk/static/images/videos/fullsize/03298.jpg",
  aspectRatio: "16:9",
};

type LiveContainerType = {
  title: string | "";
  url: string | "";
  banner: string | "";
};

function LiveBox(props: LiveContainerType) {
  return (
    <div className="card neumorph neumorph-videobox">
      <VideoPlayer {...videoJsOptions} />
      <div className="card-body">
        <p className="card-text caption-overflow">{props.title}</p>
      </div>
    </div>
  );
}

function Main() {
  const [isLive, setIsLive] = useState(false);
  let liveInfo: LiveContainerType = {
    title: "This is a test",
    url: "",
    banner: "",
  };
  return (
    <SimpleBar style={{ maxHeight: "93%", maxWidth: "100%" }}>
      {
        ///// ADD IN TEXT TITLE
        //// ADD IN SLIDE SHOW
      }
      {isLive == true && <LiveBox {...liveInfo} />}
      <div className="container-fluid" style={{ paddingTop: "2rem" }}>
        <div className="row justify-content-center">
          {testdata.map(function (e, i) {
            return (
              <VideoContainer
                title={e.title}
                link={"http://ystv.co.uk" + e.link}
                image={"http://ystv.co.uk" + e.image}
                key={i}
              />
            );
          })}
        </div>
      </div>
    </SimpleBar>
  );
}

export default Main;
