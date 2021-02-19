//
//  File Name:  PKDataManager.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/10 17:14
//

import Foundation

class PKDataManager: NSObject {
    
    static let shared = PKDataManager.init()
    
    enum Style: Int {
        case wallpaper
        case video
    }
    
    enum Status: Int {
        case show
        case hide
    }
    
    fileprivate enum Key: String {
        case style = "pk.data.wallpaper.style"
        case daily = "pk.data.daily"
        case iconStatus = "pk.data.icon.status"
        case startUp = "pk.data.start.up"
        
        case video = "pk.data.video"
        case videoPage = "pk.data.video.page"
        case videoIndex = "pk.data.video.index"
        case videoPath = "pk.data.video.path"
        case wallpaper = "pk.data.wallpaper"
        case wallpaperPaage = "pk.data.wallpaper.page"
        case wallpaperIndex = "pk.data.wallpaper.index"
        case wallpaperPath = "pk.data.wallpaper.path"
    }
    
    var style: Style = .video {
        didSet {
            UserDefaults.standard.setValue(style.rawValue, forKey: Key.style.rawValue)
        }
    }
    var isDaily: Bool = true {
        didSet {
            UserDefaults.standard.setValue(isDaily, forKey: Key.daily.rawValue)
        }
    }
    var iconStatus: Status = .show {
        didSet {
            UserDefaults.standard.setValue(iconStatus.rawValue, forKey: Key.iconStatus.rawValue)
        }
    }
    var isStartUp: Bool = false {
        didSet {
            UserDefaults.standard.setValue(isStartUp, forKey: Key.startUp.rawValue)
        }
    }
    
    // video模型数组
    var videos: [PKVideoModel] = [] {
        didSet {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: videos, requiringSecureCoding: false)
            UserDefaults.standard.setValue(data, forKey: Key.video.rawValue)
        }
    }
    // 当前video页数
    var currentVideoPage = 0 {
        didSet {
            UserDefaults.standard.setValue(currentVideoPage, forKey: Key.videoPage.rawValue)
        }
    }
    // 当前video下标
    var currentVideoIndex = 0 {
        didSet {
            UserDefaults.standard.setValue(currentVideoIndex, forKey: Key.videoIndex.rawValue)
        }
    }
    // 当前视频路径
    var currentVideoPath: String? {
        didSet {
            UserDefaults.standard.setValue(currentVideoPath, forKey: Key.videoPath.rawValue)
        }
    }
    // wallpaper模型数组
    var wallpapers: [PKWallpaperModel] = [] {
        didSet {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: wallpapers, requiringSecureCoding: false)
            UserDefaults.standard.setValue(data, forKey: Key.wallpaper.rawValue)
        }
    }
    // 当前wallpaper页数
    var currentWallpaperPage = 0 {
        didSet {
            UserDefaults.standard.setValue(currentWallpaperPage, forKey: Key.wallpaperPaage.rawValue)
        }
    }
    // 当前wallpaper下标
    var currentWallpaperIndex = 0 {
        didSet {
            UserDefaults.standard.setValue(currentWallpaperIndex, forKey: Key.wallpaperIndex.rawValue)
        }
    }
    // 当前壁纸路径
    var currentWallpaperPath: String? {
        didSet {
            UserDefaults.standard.setValue(currentWallpaperPath, forKey: Key.wallpaperPath.rawValue)
        }
    }
    
    override init() {
        if let rawValue = UserDefaults.standard.object(forKey: Key.style.rawValue) as? Int {
            style = Style.init(rawValue: rawValue) ?? .video
        }
        if let rawValue = UserDefaults.standard.object(forKey: Key.daily.rawValue) as? Bool {
            isDaily = rawValue
        }
        if let rawValue = UserDefaults.standard.object(forKey: Key.iconStatus.rawValue) as? Int {
            iconStatus = Status.init(rawValue: rawValue) ?? .show
        }
        if let rawValue = UserDefaults.standard.object(forKey: Key.startUp.rawValue) as? Bool {
            isStartUp = rawValue
        }
        if let rawValue = UserDefaults.standard.object(forKey: Key.videoPage.rawValue) as? Int {
            currentVideoPage = rawValue
        }
        if let rawValue = UserDefaults.standard.object(forKey: Key.wallpaperPaage.rawValue) as? Int {
            currentWallpaperPage = rawValue
        }
        if let rawValue = UserDefaults.standard.object(forKey: Key.videoIndex.rawValue) as? Int {
            currentVideoIndex = rawValue
        }
        if let rawValue = UserDefaults.standard.object(forKey: Key.wallpaperIndex.rawValue) as? Int {
            currentWallpaperIndex = rawValue
        }
        currentVideoPath = UserDefaults.standard.object(forKey: Key.videoPath.rawValue) as? String
        currentWallpaperPath = UserDefaults.standard.object(forKey: Key.wallpaperPath.rawValue) as? String
        if let rawValue = UserDefaults.standard.object(forKey: Key.video.rawValue) as? Data {
            let unarchiver = try? NSKeyedUnarchiver.init(forReadingFrom: rawValue)
            unarchiver?.requiresSecureCoding = false
            videos = (try? unarchiver?.decodeTopLevelObject(forKey: NSKeyedArchiveRootObjectKey) as? [PKVideoModel]) ?? []
        }
        if let rawValue = UserDefaults.standard.object(forKey: Key.wallpaper.rawValue) as? Data {
            let unarchiver = try? NSKeyedUnarchiver.init(forReadingFrom: rawValue)
            unarchiver?.requiresSecureCoding = false
            wallpapers = (try? unarchiver?.decodeTopLevelObject(forKey: NSKeyedArchiveRootObjectKey) as? [PKWallpaperModel]) ?? []
        }
    }
    
    func cleanCache() {
        try? FileManager.default.removeItem(atPath: PKConfig.wallpaperPath())
        try? FileManager.default.removeItem(atPath: PKConfig.videoPath())
    }
}
