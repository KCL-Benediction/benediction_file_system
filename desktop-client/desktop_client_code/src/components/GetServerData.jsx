import React from "react";
import "../css/main.css";
import ClickableFileElement from "./ClickableFileElement";

class GetServerData extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      files: []
    };
  }

  componentDidMount() {
    fetch("http://52.151.113.157/get_all_file_details", {
      method: "GET",
      headers: {
        Accept: "application/json"
      }
    }).then(response => {
      response.json().then(
        json => {
          this.setState({
            files: [json.files]
          });
        },
        () => {
          console.log("json rejected");
        }
      );
    });
  }

  render() {
    let temp = this.state.files[0];
    console.log(temp);

    return !!temp
      ? temp.map(file => {
          return (
            // <div className="file" key={file.file_id}>
            //   <p>{this.getFileExtension(file.file_name)}</p>
            //   <p>{file.file_name}</p>
            // </div>

            <ClickableFileElement
              image={selectImage(getFileExtension(file.file_name))}
              title={file.file_name}
              click={() => {}}
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

//const fileExtensions = ["png", "jpg", "txt", "docx", "mp3"];

export default GetServerData;
