//
//  File Name:  PKWallpaperModel.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/11 15:09
//

import Cocoa
import HandyJSON

class PKWallpaperModel: NSObject, HandyJSON, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(pageURL, forKey: "pageURL")
        coder.encode(type, forKey: "type")
        coder.encode(tags, forKey: "tags")
        coder.encode(previewURL, forKey: "previewURL")
        coder.encode(previewWidth, forKey: "previewWidth")
        coder.encode(previewHeight, forKey: "previewHeight")
        coder.encode(webformatURL, forKey: "webformatURL")
        coder.encode(webformatWidth, forKey: "webformatWidth")
        coder.encode(webformatHeight, forKey: "webformatHeight")
        coder.encode(largeImageURL, forKey: "largeImageURL")
        coder.encode(fullHDURL, forKey: "fullHDURL")
        coder.encode(imageURL, forKey: "imageURL")
        coder.encode(imageWidth, forKey: "imageWidth")
        coder.encode(imageHeight, forKey: "imageHeight")
        coder.encode(imageSize, forKey: "imageSize")
        coder.encode(views, forKey: "views")
        coder.encode(downloads, forKey: "downloads")
        coder.encode(likes, forKey: "likes")
        coder.encode(comments, forKey: "comments")
        coder.encode(user_id, forKey: "user_id")
        coder.encode(user, forKey: "user")
        coder.encode(userImageURL, forKey: "userImageURL")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey:"id") as! String
        pageURL = coder.decodeObject(forKey: "pageURL") as! String
        type = coder.decodeObject(forKey: "type") as! String
        tags = coder.decodeObject(forKey: "tags") as! String
        previewURL = coder.decodeObject(forKey: "previewURL") as! String
        previewWidth = coder.decodeInteger(forKey: "previewWidth")
        previewHeight = coder.decodeInteger(forKey: "previewHeight")
        webformatURL = coder.decodeObject(forKey: "webformatURL") as! String
        webformatWidth = coder.decodeInteger(forKey: "webformatWidth")
        webformatHeight = coder.decodeInteger(forKey: "webformatHeight")
        largeImageURL = coder.decodeObject(forKey: "largeImageURL") as! String
        fullHDURL = coder.decodeObject(forKey: "fullHDURL") as! String
        imageURL = coder.decodeObject(forKey: "imageURL") as! String
        imageWidth = coder.decodeInteger(forKey: "imageWidth")
        imageHeight = coder.decodeInteger(forKey: "imageHeight")
        imageSize = coder.decodeInteger(forKey: "imageSize")
        views = coder.decodeInteger(forKey: "views")
        downloads = coder.decodeInteger(forKey: "downloads")
        likes = coder.decodeInteger(forKey: "likes")
        comments = coder.decodeInteger(forKey: "comments")
        user_id = coder.decodeObject(forKey: "user_id") as! String
        user = coder.decodeObject(forKey: "user") as! String
        userImageURL = coder.decodeObject(forKey: "userImageURL") as! String
    }
    
    var id: String = ""
    var pageURL: String = ""
    var type: String = ""
    var tags: String = ""
    var previewURL: String = ""
    var previewWidth: Int = 0
    var previewHeight: Int = 0
    var webformatURL: String = ""
    var webformatWidth: Int = 0
    var webformatHeight: Int = 0
    var largeImageURL: String = ""
    var fullHDURL: String = ""
    var imageURL: String = ""
    var imageWidth: Int = 0
    var imageHeight: Int = 0
    var imageSize: Int = 0
    var views: Int = 0
    var downloads: Int = 0
    var likes: Int = 0
    var comments: Int = 0
    var user_id: String = ""
    var user: String = ""
    var userImageURL: String = ""
    
    required override init() {}
}
