//
//  File Name:  PKConfig.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/9 16:31
//

import Foundation

struct PKConfig {
    fileprivate static let baseTag = 1857
    
    enum MenuTag: Int {
        case next = 0
        case video = 1
        case wallpaper = 2
        case local = 3
        case daily = 4
        case export = 5
        case showIcon = 6
        case hideIcon = 7
        case start = 8
        case help = 9
        case about = 10
        case feedback = 11
        case exit = 12
    }
    
    static func getTag(_ tag: MenuTag) -> Int {
        return baseTag + tag.rawValue
    }
    
    static func wallpaperPath() -> String {
        var defaultPath: String = ""
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            defaultPath = path + "/PaperKite/Wallpaper/"
        } else {
            defaultPath = NSHomeDirectory() + "/Documents/PaperKite/Wallpaper/"
        }
        return defaultPath
    }
    
    static func videoPath() -> String {
        var defaultPath: String = ""
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            defaultPath = path + "/PaperKite/Video/"
        } else {
            defaultPath = NSHomeDirectory() + "/Documents/PaperKite/Video/"
        }
        return defaultPath
    }
    
    // pixabay key
    static let pixabayAccesskey = "12956784-91c84f326fcbd73df660f8c5b"
    
    // 启动项辅助程序bundle id
    static let helperBundleIdentifier = "com.liyb.PaperKiteLaunchHelper"
    
    // 更新动态壁纸通知
    static let updateVideoNotification = NSNotification.Name.init("pk.update.video.notification")
    // 下一个壁纸通知
    static let nextWallpaperNotification = NSNotification.Name.init("pk.next.wallpaper.notification")
    // 保存壁纸通知
    static let saveWallpaperNotification = NSNotification.Name.init("pk.save.wallpaper.notification")
    
    // DEBUG
    static func log(_ message: Any) {
        #if DEBUG
        print(message)
        #endif
    }
}
