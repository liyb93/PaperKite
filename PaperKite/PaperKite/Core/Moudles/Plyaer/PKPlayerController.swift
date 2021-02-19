//
//  File Name:  PKPlayerController.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/9 17:48
//

import Cocoa

class PKPlayerController: NSViewController {

    @IBOutlet weak var playerView: PKPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateVideo(_:)), name: PKConfig.updateVideoNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nextWallpaper(_:)), name: PKConfig.nextWallpaperNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateVideo(_ notifiacation: NSNotification) {
        playerView.videoURL = notifiacation.userInfo?["path"] as? URL
    }
    
    @objc private func nextWallpaper(_ notification: NSNotification) {
        if PKDataManager.shared.style == .video {
            PKNetwork.shared.video { [unowned self] (url) in
                self.playerView.videoURL = url
                print("下一个视频")
            } failure: {
                PKAlert.show("视频获取失败请重试")
            }
        } else {
            PKNetwork.shared.wallpaper { (url) in
                if let screen = NSScreen.main {
                    try? NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [NSWorkspace.DesktopImageOptionKey.imageScaling: NSImageScaling.scaleAxesIndependently.rawValue])
                } else {
                    PKAlert.show("壁纸获取失败请重试")
                }
            } failure: {
                PKAlert.show("壁纸获取失败请重试")
            }
        }
    }
}
