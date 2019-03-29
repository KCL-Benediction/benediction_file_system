//
//  GlobalHelper.swift
//  DocumentTest
//
//  Copyright © 2019 perrion huds. All rights reserved.
//

// fix the bug of showing images in cloud files
import UIKit
public extension String
{
    var pathExtension: String
    {
        guard let url = URL(string: self) else { return "" }
        return url.pathExtension.isEmpty ? "" : "\(url.pathExtension)"
    }
}
class GlobalHelper: NSObject {
    static let instance: GlobalHelper = GlobalHelper()
    class func SharedInstnce() -> GlobalHelper
    {
        return instance
    }
    func GetImageByFileType(type:String) -> AllPossibilities
    {
        return AllPossibilities(rawValue: type) ?? .Default
    }
}
