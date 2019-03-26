import React from "react";
import "../css/main.css";
import ClickableFileElement from "./ClickableFileElement";

import AuthService from "./AuthService";
const Auth = new AuthService("http://34.73.231.127");

var connection = new WebSocket("ws://34.73.231.127");

class GetServerData extends React.Component {
  constructor(props) {
    super(props);
    this.handleDoubleClickItem = this.handleDoubleClickItem.bind(this);
    this.state = {
      files: []
    };
  }

  fetchFileDetails = () => {
    fetch("http://34.73.231.127/get_all_file_details", {
      method: "GET",
      mode: "cors",
      headers: {
        Accept: "application/json",
        Authorization: "Bearer " + Auth.getToken()
      }
    }).then(response => {
      response.json().then(
        json => {
          this.setState({
            files: [json.files]
          });
          console.log(this.state.files);
        },
        () => {
          console.log("json rejected");
        }
      );
    });
  };

  componentDidMount() {
    this.fetchFileDetails();
    this.fileUpdate();
  }

  fileUpdate = () => {
    // console.log("fff");
    connection.onmessage = event => {
      this.fetchFileDetails();
    };
  };

  //to download file
  handleDoubleClickItem(clickedFileId) {
    // alert("I got double-clicked!");
    let findFile = this.state.files[0];

    let fileIdx = findFile.reduce(
      (acc, file) => {
        if (!acc.found) {
          if (file.file_id === clickedFileId) {
            acc.found = true;
            return acc;
          }
          acc.foundAt += 1;
          return acc;
        } else {
          return acc;
        }
      },
      { found: false, foundAt: 0 }
    );
    // console.log(fileIdx);

    let temp = this.state.files[0][fileIdx.foundAt];
    let fileID = temp.url;
    let fileName = temp.file_name;
    let fileInfo = this.state.files[0][fileIdx.foundAt];

    const http = window.require("http");
    const fs = window.require("fs");
    const file = fs.createWriteStream("./benedictionFiles/newfile_" + fileName);
    const request = http.get(
      fileID,
      {
        headers: {
          Accept: "application/json",
          Authorization: "Bearer " + Auth.getToken()
        },
        responseType: "blob" // important
      },
      function(response) {
        response.on("end", () => {
          alert("Download Finished.");
          //write file details to json file to support locking
          var obj = {};
          fs.readFile("./public/files.json", "utf-8", (error, content) => {
            if (!error) {
              obj = JSON.parse(content);
            }
            obj[fileInfo.file_id] = fileInfo;
            fs.writeFile(
              "./public/files.json",
              JSON.stringify(obj),
              (error, somthing) => {}
            );
          });
        });
        response.on("data", chunck => {
          console.log("chunck: ", chunck);
        });
        response.pipe(file);
      }
    );
  }

  render() {
    let temp = this.state.files[0];
    //displaying the uploaded files
    return !!temp
      ? temp.map(file => {
          return (
            <ClickableFileElement
              image={selectImage(getFileExtension(file.file_name))}
              title={file.file_name}
              DoubleClick={() => this.handleDoubleClickItem(file.file_id)}
              key={file.file_id}
            />
          );
        })
      : null;
  }
}

const getFileExtension = fileExe => {
  return /[.]/.exec(fileExe) ? /[^.]+$/.exec(fileExe)[0] : undefined;
};

const selectImage = extension => {
  switch (extension) {
    //images
    case "png":
    case "PNG":
      return "png.png";
    case "jpg":
    case "JPG":
    case "jpeg":
      return "jpg.png";
    case "svg":
    case "SVG":
      return "svg.png";
    case "gif":
    case "GIF":
      return "GIF.svg";
    //documents
    case "txt":
      return "txt.png";
    case "docx":
    case "doc":
      return "doc.png";
    case "pdf":
      return "pdf.png";
    case "ppt":
    case "pptx":
      return "ppt.png";
    case "xlr":
    case "xls":
    case "xlsx":
      return "ppt.png";
    case "rtf":
    case "RTF":
      return "rtf.png";
    case "zip":
    case "7z":
    case "rar":
    case "z":
      return "zip.png";
    case "pkg":
      return "pkg.png";
    case "csv":
      return "csv.png";
    case "db":
    case "dbf":
    case "sql":
    case "mdb":
      return "dbf.png";
    case "xml":
      return "xml.png";
    //audios videos
    case "mp3":
      return "mp3.png";
    case "mid":
    case "midi":
    case "wav":
    case "wma":
      return "music_file.png";
    case "avi":
      return "avi.png";
    case "mov":
      return "mov.png";
    case "mp4":
      return "mp4.png";
    case "wmv":
      return "wmv.png";
    case "flv":
    case "m4v":
    case "mpg":
    case "mpeg":
      return "video.png";
    //programming files
    case "css":
      return "css.png";
    case "html":
      return "html.png";
    case "js":
      return "js.png";
    case "json":
      return "json.png";

    default:
      return "file.png";
  }
};

export default GetServerData;
