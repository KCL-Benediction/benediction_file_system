var fs = window.require('fs');
var globalC = '';

export function writeToFile(data) {

    fs.writeFile('./public/codeFile.txt', data, function(err) {
        if(err) {
           console.log(err);
        }
       
    }); 
}


