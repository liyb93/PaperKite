//
//  File Name:  PKNetwork.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/10 18:01
//

import Foundation
import Alamofire
import HandyJSON

struct PKNetwork {
    
    static let shared = PKNetwork()
    
    func cancelAllRequests() {
        AF.cancelAllRequests()
    }
    
    func wallpaper(_ success:((URL)->())?, failure:(()->())?) {
        let wallpapers = PKDataManager.shared.wallpapers
        let index = PKDataManager.shared.currentWallpaperIndex + 1
        PKDataManager.shared.currentWallpaperIndex = index
        if wallpapers.count > 0, index < wallpapers.count, index >= 0 {
            let wallpaper = wallpapers[index]
            downloadWallpaper(wallpaper.largeImageURL, update: true, success: success, failure: failure)
            return
        }
        guard let url = URL.init(string: "https://pixabay.com/api/") else {
            return
        }
        PKDataManager.shared.currentWallpaperPage += 1
        AF.request(url, method: .get, parameters: ["key": PKConfig.pixabayAccesskey, "page": PKDataManager.shared.currentWallpaperPage, "per_page": "20"]).responseJSON { (response) in
            if let value = response.value as? [String: Any], let values = [PKWallpaperModel].deserialize(from: value["hits"] as? [Any]) as? [PKWallpaperModel] {
                PKDataManager.shared.wallpapers = values
                PKDataManager.shared.currentWallpaperIndex = 0
                // 下载壁纸
                let wallpaper = wallpapers[index]
                downloadWallpaper(wallpaper.largeImageURL, update: true, success: success, failure: failure)
            } else {
                failure?()
            }
        }
    }
    
    func video(_ success:((URL)->())?, failure:(()->())?) {
        let videos = PKDataManager.shared.videos
        let index = PKDataManager.shared.currentVideoIndex + 1
        PKDataManager.shared.currentVideoIndex = index
        if videos.count > 0, index < videos.count, index >= 0 {
            let video = videos[index]
            downloadVideo(video.videos.large.url, update: true, success: success, failure: failure)
            return
        }
        guard let url = URL.init(string: "https://pixabay.com/api/videos/") else {
            return
        }
        PKDataManager.shared.currentVideoPage += 1
        AF.request(url, method: .get, parameters: ["key": PKConfig.pixabayAccesskey, "page": PKDataManager.shared.currentVideoPage, "per_page": "20"]).responseJSON { (response) in
            if let value = response.value as? [String: Any], let values = [PKVideoModel].deserialize(from: value["hits"] as? [Any]) as? [PKVideoModel] {
                PKDataManager.shared.videos = values
                PKDataManager.shared.currentVideoIndex = 0
                let video = videos[index]
                downloadVideo(video.videos.large.url, update: true, success: success, failure: failure)
            } else {
                failure?()
            }
        }
    }
    
    func downloadWallpaper(_ urlString: String, update: Bool = false, success:((URL)->())?, failure:(()->())?) {
        if let url = URL.init(string: urlString) {
            let filename = urlString.md5()
            let fileUrl = URL.init(fileURLWithPath: PKConfig.wallpaperPath() + filename + ".jpg")
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                PKConfig.log("开始下载壁纸: \(url.path)")
                if update {
                    try? FileManager.default.removeItem(at: fileUrl)
                    AF.download(url).responseURL { (response) in
                        if let value = response.value {
                            do {
                                try FileManager.default.copyItem(at: value, to: fileUrl)
                                PKDataManager.shared.currentWallpaperPath = fileUrl.path
                                PKConfig.log("下载完成: \(fileUrl.path)")
                                success?(fileUrl)
                            } catch {
                                PKConfig.log("下载完成，拷贝失败: \(value.path)")
                                success?(value)
                            }
                        } else {
                            PKConfig.log("下载失败: \(response.error!)")
                            failure?()
                        }
                    }
                } else {
                    PKConfig.log("不更新: \(fileUrl.path)")
                    success?(fileUrl)
                }
            } else {
                if !FileManager.default.fileExists(atPath: PKConfig.wallpaperPath()) {
                    let url = URL.init(fileURLWithPath: PKConfig.wallpaperPath())
                    try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                }
                PKConfig.log("开始下载壁纸: \(url.path)")
                AF.download(url).responseURL { (response) in
                    if let value = response.value {
                        do {
                            try FileManager.default.copyItem(at: value, to: fileUrl)
                            PKDataManager.shared.currentWallpaperPath = fileUrl.path
                            PKConfig.log("下载完成: \(fileUrl.path)")
                            success?(fileUrl)
                        } catch {
                            PKConfig.log("下载完成，拷贝失败: \(value.path)")
                            success?(value)
                        }
                    } else {
                        PKConfig.log("下载失败: \(response.error!)")
                        failure?()
                    }
                }
            }
        } else {
            PKConfig.log("下载失败 地址错误")
            failure?()
        }
    }
    
    func downloadVideo(_ urlString: String, update: Bool = false, success:((URL)->())?, failure:(()->())?) {
        if let url = URL.init(string: urlString) {
            let filename = urlString.md5()
            let fileUrl = URL.init(fileURLWithPath: PKConfig.videoPath() + filename + ".mp4")
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                PKConfig.log("开始下载视频: \(url.path)")
                if update {
                    try? FileManager.default.removeItem(at: fileUrl)
                    AF.download(url).responseURL { (response) in
                        if let value = response.value {
                            do {
                                try FileManager.default.copyItem(at: value, to: fileUrl)
                                PKDataManager.shared.currentVideoPath = fileUrl.path
                                PKConfig.log("下载完成: \(fileUrl.path)")
                                success?(fileUrl)
                            } catch {
                                PKConfig.log("下载完成，拷贝失败: \(value.path)")
                                success?(value)
                            }
                        } else {
                            PKConfig.log("下载失败: \(response.error!)")
                            failure?()
                        }
                    }
                } else {
                    PKConfig.log("不更新: \(fileUrl.path)")
                    success?(fileUrl)
                }
            } else {
                if !FileManager.default.fileExists(atPath: PKConfig.videoPath()) {
                    let url = URL.init(fileURLWithPath: PKConfig.videoPath())
                    do {
                        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print("")
                    }
                }
                PKConfig.log("开始下载视频: \(url.path)")
                AF.download(url).responseURL { (response) in
                    if let value = response.value {
                        do {
                            try FileManager.default.copyItem(at: value, to: fileUrl)
                            PKDataManager.shared.currentVideoPath = fileUrl.path
                            PKConfig.log("下载完成: \(fileUrl.path)")
                            success?(fileUrl)
                        } catch {
                            PKConfig.log("下载完成，拷贝失败: \(value.path)")
                            success?(value)
                        }
                    } else {
                        PKConfig.log("下载失败: \(response.error!)")
                        failure?()
                    }
                }
            }
        } else {
            PKConfig.log("下载失败 地址错误")
            failure?()
        }
    }
}
