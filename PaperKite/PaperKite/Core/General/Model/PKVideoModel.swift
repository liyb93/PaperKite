//
//  File Name:  PKVideoModel.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/11 15:10
//

import Cocoa
import HandyJSON

class PKVideoModel: NSObject, HandyJSON, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(pageURL, forKey: "pageURL")
        coder.encode(type, forKey: "type")
        coder.encode(tags, forKey: "tags")
        coder.encode(duration, forKey: "duration")
        coder.encode(picture_id, forKey: "picture_id")
        coder.encode(views, forKey: "views")
        coder.encode(downloads, forKey: "downloads")
        coder.encode(favorites, forKey: "favorites")
        coder.encode(likes, forKey: "likes")
        coder.encode(comments, forKey: "comments")
        coder.encode(videos, forKey: "videos")
        coder.encode(user_id, forKey: "user_id")
        coder.encode(user, forKey: "user")
        coder.encode(userImageURL, forKey: "userImageURL")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey:"id") as! String
        pageURL = coder.decodeObject(forKey: "pageURL") as! String
        type = coder.decodeObject(forKey: "type") as! String
        tags = coder.decodeObject(forKey: "tags") as! String
        picture_id = coder.decodeObject(forKey: "picture_id") as! String
        duration = coder.decodeInteger(forKey: "duration")
        views = coder.decodeInteger(forKey: "views")
        downloads = coder.decodeInteger(forKey: "downloads")
        favorites = coder.decodeInteger(forKey: "favorites")
        likes = coder.decodeInteger(forKey: "likes")
        comments = coder.decodeInteger(forKey: "comments")
        user_id = coder.decodeObject(forKey: "user_id") as! String
        user = coder.decodeObject(forKey: "user") as! String
        userImageURL = coder.decodeObject(forKey: "userImageURL") as! String
        videos = coder.decodeObject(forKey: "videos") as? PKVideoItemModel
    }
    
    required override init() {}
    
    var id: String = ""
    var pageURL: String = ""
    var type: String = ""    // 类别
    var tags: String = ""   // 标签
    var duration: Int = 0   // 时长
    var picture_id: String = ""
    var views: Int = 0  // 观看数
    var downloads: Int = 0  // 下载数
    var favorites: Int = 0  // 关注数
    var likes: Int = 0  // 喜欢数
    var comments: Int = 0   // 评论数
    var user_id: String = ""
    var user: String = ""    // 用户名
    var userImageURL: String = ""    // 用户头像
    var videos: PKVideoItemModel!
}

class PKVideoItemModel: NSObject, HandyJSON, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(large, forKey: "large")
        coder.encode(medium, forKey: "medium")
        coder.encode(small, forKey: "small")
        coder.encode(tiny, forKey: "tiny")
    }
    
    required init?(coder: NSCoder) {
        large = coder.decodeObject(forKey: "large") as? PKVideoInfoModel
        medium = coder.decodeObject(forKey: "medium") as? PKVideoInfoModel
        small = coder.decodeObject(forKey: "small") as? PKVideoInfoModel
        tiny = coder.decodeObject(forKey: "tiny") as? PKVideoInfoModel
    }
    
    required override init() {}
    
    var large: PKVideoInfoModel!
    var medium: PKVideoInfoModel!
    var small: PKVideoInfoModel!
    var tiny: PKVideoInfoModel!
}


class PKVideoInfoModel: NSObject, HandyJSON, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(url, forKey: "url")
        coder.encode(width, forKey: "width")
        coder.encode(height, forKey: "height")
        coder.encode(size, forKey: "size")
    }
    
    required init?(coder: NSCoder) {
        width = coder.decodeInteger(forKey: "width")
        height = coder.decodeInteger(forKey: "height")
        size = coder.decodeInteger(forKey: "size")
        url = coder.decodeObject(forKey: "url") as! String
        
    }
    
    required override init() {}
    
    var url: String = ""
    var width: Int = 0
    var height: Int = 0
    var size: Int = 0
}
