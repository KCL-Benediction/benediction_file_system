// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.
const { shell } = require('electron')
const fs = require('fs');
const folderImageUrl = 'https://i.imgur.com/KOVrtbf.png'
const fileImageUrl = 'https://i.imgur.com/guAfUJd.png'
const lastPageImageUrl = 'https://i.imgur.com/j93mjsG.png';
const backButtonTitle = "。。。";
let currentPath = "/Users/dannyyaou";

function changePath(path) {
	currentPath = path;
	document.getElementById('fileList').innerHTML = "";
	document.getElementById('path').innerHTML = path;
	let files = fs.readdirSync(path);
	let node, textnode;
	node = createNode(backButtonTitle);
	document.getElementById("fileList").appendChild(node);
	for (var i = 0; i < files.length; i++) {
		node = createNode(files[i])
		if (node) {
			document.getElementById("fileList").appendChild(node);
		}
	}
	bindEventToButton()
}
function bindEventToButton(){
	var list = document.getElementsByClassName('fileDiv');
	for (var i = 0; i < list.length; i++) {
		list[i].addEventListener('click',(event)=>{
			for (var i = 0; i < event.path.length; i++) {
				if(event.path[i].tagName === 'BUTTON'){
					var newFileName = event.path[i].className.split("fileName-")[1];
					console.log(newFileName)
					if (newFileName === backButtonTitle) {
						var newPath = currentPath.split("/").splice(0,currentPath.split("/").length-1).join("/");
					}else{
						var newPath = currentPath + "/" + newFileName;
					}
					if (!newPath) {
						newPath = '/'
					}
					if (event.path[i].className.split(" ")[1] == 'fileType-file') {
						shell.openItem(newPath)
					}else{
						changePath(newPath)
					}
				}
			}
		})
	}
}
function createNode(fileName){
	if (fileName[0] !== '.') {
  	node = document.createElement("button");
	  image = document.createElement('img');
	  if(fileName === backButtonTitle){
	  	image.setAttribute('src',lastPageImageUrl)
	  	node.setAttribute("class","fileDiv fileType-folder fileName-"+fileName);
	  }else if (fileName.indexOf(".")>=0) {
	  	image.setAttribute('src',fileImageUrl);
	  	node.setAttribute("class","fileDiv fileType-file fileName-"+fileName);
	  }else{
	  	image.setAttribute('src',folderImageUrl)
	  	node.setAttribute("class","fileDiv fileType-folder fileName-"+fileName);
	  }
	  image.setAttribute('class',"fileImage")
	  fileTitle = document.createElement('p');
	  if (fileName.length > 15) {
	  	fileName = fileName.substring(0,15) + "...";
	  }
	  fileTitle.innerHTML = fileName;
	  node.appendChild( image );
	  node.appendChild( fileTitle );
	  return node;
  }else{
  	return null;
  }
}

changePath(currentPath)
document.querySelector('#filePath').addEventListener('change', changePath)