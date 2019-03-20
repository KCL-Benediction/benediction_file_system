import React from "react";
import axios from "axios";

class DownloadFile extends React.Component {
  constructor(props) {
    super(props);
    this._handleDoubleClickItem = this._handleDoubleClickItem.bind(this);
  }

  _handleDoubleClickItem(event) {
    // alert("I got double-clicked!");
    axios({
      url:
        "http://52.151.113.157/download_a_file?file_id=pf5marhtrB4hbwtDOYXIVohFhBHJGUuX",
      method: "GET",
      responseType: "blob" // important
    }).then(response => {
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", "filename.png");
      document.body.appendChild(link);
      link.click();
    });
  }

  render() {
    return <ul onDoubleClick={this._handleDoubleClickItem} />;
  }
}

export default DownloadFile;
