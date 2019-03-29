import Foundation
import UIKit

public enum AllPossibilities: String
{
    case JS="js"
    case AVI="avi"
    case WMV="wmv"
    case GIF = "gif"
    case JPG = "jpg"
    case JSON = "json"
    case PDF = "pdf"
    case PLIST = "plist"
    case PNG = "png"
    case ZIP = "zip"
    case MP3 = "mp3"
    case MP4 = "mp4"
    case DOC="docx"
    case RTF="rtf"
    case Default = "file"
    case Directory = "directory"
    
    public func image() -> UIImage?
    {
        let bundle =  Bundle(for: FileParser.self)
        var fileName = String()
        //print (AllPossibilities.Default)
        switch self
        {
        case .WMV: fileName = "wmv.png"
        case .AVI: fileName = "avi.png"
        case .JPG: fileName = "jpg.png"
        case .PNG: fileName="png.png"
        case .GIF: fileName="gif.png"
        case .MP3: fileName="mp3.png"
        case .MP4: fileName="mp4.png"
        case .PDF: fileName = "pdf.png"
        case .ZIP: fileName = "zip.png"
        case .DOC: fileName="doc.png"
        case .RTF: fileName="rtf.png"
        case .Directory: fileName = "folder.png"
        default: fileName = "file.png"
        }
        let file = UIImage(named: fileName, in: bundle, compatibleWith: nil)
        return file
    }
}


@objc public class TranslateFiles: NSObject
{
    @objc public let displayName: String
    public let isDirectory: Bool
    public let fileExtension: String?
    public let fileAttributes: NSDictionary?
    public let filePath: URL
    public let type: AllPossibilities
    
    open func delete()
    {
        do
        {
            try FileManager.default.removeItem(at: self.filePath)
        }
        catch
        {
            print("An error occured when trying to delete file:\(self.filePath) Error:\(error)")
        }
    }
    
    init(filePath: URL)
    {
        self.filePath = filePath
        let isDirectory = checkDirectory(filePath)
        self.isDirectory = isDirectory
        if self.isDirectory
        {
            self.fileAttributes = nil
            self.fileExtension = nil
            self.type = .Directory
        }
        else
        {
            self.fileAttributes = getFileAttributes(self.filePath)
            self.fileExtension = filePath.pathExtension
            if let fileExtension = fileExtension {
                self.type = AllPossibilities(rawValue: fileExtension) ?? .Default
            }
            else
            {
                self.type = .Default
            }
        }
        self.displayName = filePath.lastPathComponent
    }
}
