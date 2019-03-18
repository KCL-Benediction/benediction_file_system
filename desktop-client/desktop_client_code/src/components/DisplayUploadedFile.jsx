import React from "react";

class DisplayUploadedFile extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      imgSrc: null,
      title: "filename"
    };
  }

  handleDisplayFile(files) {
    const currentFile = files[0];
    const fileItem = new FileReader();
    fileItem.addEventListener(
      "load",
      () => {
        console.log(files[0].name);
        this.setState({
          imgSrc: fileItem.result,
          title: files[0].name
        });
      },
      false
    );

    fileItem.readAsDataURL(currentFile);
  }

  render() {
    const { imgSrc, title } = this.state;
    return (
      <div>
        {imgSrc !== null ? (
          <div className="displayFile">
            <img src={imgSrc} alt="uploadedFile" />
            <p>{title}</p>{" "}
          </div>
        ) : (
          ""
        )}
      </div>
    );
  }
}

export default DisplayUploadedFile;
