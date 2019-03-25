import React from "react";
import "../css/main.css";
import ClickableFileElement from "./ClickableFileElement";

import AuthService from "./AuthService";
const Auth = new AuthService("http://34.73.231.127");

class GetServerData extends React.Component {
  constructor(props) {
    super(props);
    this.handleDoubleClickItem = this.handleDoubleClickItem.bind(this);
    this.state = {
      files: []
    };
  }

  componentDidMount() {
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
  }

  handleDoubleClickItem(clickedFileId) {
    // alert("I got double-clicked!");
    let findFile = this.state.files[0];

    // console.log(inty);

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
    const file = fs.createWriteStream("./benedictionFiles/" + fileName);
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
          alert("Download Finish");
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

    // axios({
    //   url: fileID,
    //   method: "GET",
    //   headers: {
    //     Accept: "application/json",
    //     Authorization: "Bearer " + Auth.getToken()
    //   },
    //   responseType: "blob" // important
    // }).then(response => {
    //   const url = window.URL.createObjectURL(new Blob([response.data]));
    //   const link = document.createElement("a");
    //   link.href = url;
    //   link.setAttribute("download", fileName);
    //   document.body.appendChild(link);
    //   link.click();
    // });
  }

  render() {
    let temp = this.state.files[0];

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
    case "png":
      return "picture.svg";
    case "jpg":
      return "picture.svg";
    case "txt":
      return "doc.svg";
    case "docx":
      return "doc.svg";
    case "mp3":
      return "music_file.png";
    default:
      return "folder.png";
  }
};

export default GetServerData;
