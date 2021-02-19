//
//  File Name:  AppDelegate.swift
//  Product Name:   
//  Created Date:   2021/2/9 15:48
//

import Cocoa
import ServiceManagement

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private lazy var menu: NSMenu = {
        let menu = NSMenu.init(title: "菜单")
        return menu
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configMenu()
        setupStatusBar()
        configWallpaper()
    }
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let icon = NSImage.init(named: "bar")
        icon?.isTemplate = false
        if #available(macOS 10.14, *) {
            statusItem.button?.image = icon
        } else {
            statusItem.image = icon
        }
        statusItem.menu = menu
    }
    
    private func configMenu() {
        // 移除所有item
        menu.removeAllItems()
        
        let next = NSMenuItem.init(title: "下一个", action: #selector(netWallpaper), keyEquivalent: "")
        next.tag = PKConfig.getTag(.next)
        
        let video = NSMenuItem.init(title: "动态壁纸", action: #selector(wallpaperStyle(_:)), keyEquivalent: "")
        video.tag = PKConfig.getTag(.video)
        let wallpaper = NSMenuItem.init(title: "静态壁纸", action: #selector(wallpaperStyle(_:)), keyEquivalent: "")
        wallpaper.tag = PKConfig.getTag(.wallpaper)
        if PKDataManager.shared.style == .wallpaper {
            wallpaper.state = .on
            video.state = .off
        } else {
            video.state = .on
            wallpaper.state = .off
        }
        
        let local = NSMenuItem.init(title: "选择视频", action: #selector(pickerVideo), keyEquivalent: "")
        local.tag = PKConfig.getTag(.local)
        if PKDataManager.shared.style == .wallpaper {
            local.action = nil
        }
        let export = NSMenuItem.init(title: "保存壁纸/视频", action: #selector(saveWallpaper), keyEquivalent: "")
        export.tag = PKConfig.getTag(.export)
        let daily = NSMenuItem.init(title: "每日切换", action: #selector(dailyWallpaper(_:)), keyEquivalent: "")
        daily.state = PKDataManager.shared.isDaily ? .on : .off
        daily.tag = PKConfig.getTag(.daily)
        
        let showIcon = NSMenuItem.init(title: "显示图标", action: #selector(showDesktopIcon(_:)), keyEquivalent: "")
        showIcon.tag = PKConfig.getTag(.showIcon)
        if PKDataManager.shared.style == .wallpaper {
            showIcon.action = nil
        }
        let hideIcon = NSMenuItem.init(title: "隐藏图标", action: #selector(hideDesktopIcon(_:)), keyEquivalent: "")
        hideIcon.tag = PKConfig.getTag(.hideIcon)
        if PKDataManager.shared.style == .wallpaper {
            hideIcon.action = nil
        }
        if PKDataManager.shared.iconStatus == .show {
            showIcon.state = .on
            hideIcon.state = .off
        } else {
            hideIcon.state = .on
            showIcon.state = .off
        }
        
        let start = NSMenuItem.init(title: "开机自启", action: #selector(startLoad(_:)), keyEquivalent: "l")
        start.state = PKDataManager.shared.isStartUp ? .on : .off
        start.tag = PKConfig.getTag(.start)
        
        let clean = NSMenuItem.init(title: "清除缓存", action: #selector(cleanCache), keyEquivalent: "")
        
        let help = NSMenuItem.init(title: "常见问题", action: #selector(helpDoc), keyEquivalent: "")
        help.tag = PKConfig.getTag(.help)
        let feedback = NSMenuItem.init(title: "意见反馈", action: #selector(issueFeedback), keyEquivalent: "")
        feedback.tag = PKConfig.getTag(.feedback)
        let about = NSMenuItem.init(title: "关于我们", action: #selector(aboutUs), keyEquivalent: "")
        about.tag = PKConfig.getTag(.about)
        let exit = NSMenuItem.init(title: "退出", action: #selector(exitApp), keyEquivalent: "q")
        exit.tag = PKConfig.getTag(.exit)
        menu.addItem(next)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(video)
        menu.addItem(wallpaper)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(local)
        menu.addItem(export)
        menu.addItem(NSMenuItem.separator())
        // 暂未实现
//        menu.addItem(daily)
//        menu.addItem(NSMenuItem.separator())
        menu.addItem(showIcon)
        menu.addItem(hideIcon)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(start)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(clean)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(help)
        menu.addItem(feedback)
        menu.addItem(about)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(exit)
    }
    
    // 配置壁纸
    private func configWallpaper() {
        // 取消所有请求，防止切换壁纸类型，下载完成设置混乱
        PKNetwork.shared.cancelAllRequests()
        if PKDataManager.shared.style == .video {
            // 检测是否有旧视频
            if let path = PKDataManager.shared.currentVideoPath, FileManager.default.fileExists(atPath: path) {
                let url = URL.init(fileURLWithPath: path)
                NotificationCenter.default.post(name: PKConfig.updateVideoNotification, object: nil, userInfo: ["path": url])
            } else {    // 获取新视频
                netWallpaper()
            }
        } else {
            // 移除动态壁纸
            NotificationCenter.default.post(name: PKConfig.updateVideoNotification, object: nil, userInfo: ["path": ""])
            // 检测是否有旧壁纸
            if let path = PKDataManager.shared.currentWallpaperPath, FileManager.default.fileExists(atPath: path) {
                let url = URL.init(fileURLWithPath: path)
                if let screen = NSScreen.main {
                    try? NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [NSWorkspace.DesktopImageOptionKey.imageScaling: NSImageScaling.scaleAxesIndependently.rawValue])
                } else {
                    PKAlert.show("壁纸获取失败请重试")
                }
            } else {   // 获取新壁纸
                netWallpaper()
            }
        }
    }
    
    private func openPanel(_ fileTypes: [String]? = []) -> NSOpenPanel {
        let panel = NSOpenPanel.init()
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = fileTypes
        panel.canCreateDirectories = false
        // 至于最顶层，防止被其他后打开的app覆盖
        panel.level = NSWindow.Level.init(21)
        return panel
    }
    
    /// 下一张
    @objc private func netWallpaper() {
        NotificationCenter.default.post(name: PKConfig.nextWallpaperNotification, object: nil)
    }
    
    /// 设置壁纸样式
    @objc private func wallpaperStyle(_ item: NSMenuItem) {
        item.state = .on
        
        let items = menu.items.filter { $0.tag == PKConfig.getTag(.showIcon) || $0.tag == PKConfig.getTag(.hideIcon) || $0.tag == PKConfig.getTag(.local) }
        
        if item.tag == PKConfig.getTag(.video) {    // 视频
            PKDataManager.shared.style = .video
            let wallpaperItem = menu.items.filter { $0.tag == PKConfig.getTag(.wallpaper) }.first
            wallpaperItem?.state = .off
            
            // 启用动态壁纸相关功能
            items.forEach { (item) in
                if item.tag == PKConfig.getTag(.showIcon) {
                    item.action = #selector(showDesktopIcon(_:))
                } else if item.tag == PKConfig.getTag(.hideIcon) {
                    item.action = #selector(hideDesktopIcon(_:))
                } else if item.tag == PKConfig.getTag(.local) {
                    item.action = #selector(pickerVideo)
                }
            }
        } else {
            PKDataManager.shared.style = .wallpaper
            let videoItem = menu.items.filter { $0.tag == PKConfig.getTag(.video) }.first
            videoItem?.state = .off
            
            // 禁用动态壁纸相关功能
            items.forEach { $0.action = nil }
        }
        
        // 配置壁纸
        configWallpaper()
    }
    
    // 选择本地视频
    @objc private func pickerVideo() {
        let panel = openPanel(["AVI","MP4","3GP","M4V","MOV"])
        panel.begin { (response) in
            if response == .OK, let url = panel.url {
                NotificationCenter.default.post(name: PKConfig.updateVideoNotification, object: nil, userInfo: ["path": url])
            } else {
                PKAlert.show("获取视频失败，请重试")
            }
        }
    }
    
    // 导出壁纸/视频
    @objc private func saveWallpaper() {
        var filepath: String?
        var title = ""
        var fileTypes: [String] = []
        if PKDataManager.shared.style == .video {
            filepath = PKDataManager.shared.currentVideoPath ?? ""
            title = "导出视频到"
            fileTypes = ["mp4"]
        } else {
            filepath = PKDataManager.shared.currentWallpaperPath ?? ""
            title = "导出壁纸到"
            fileTypes = ["jpg"]
        }
        guard let path = filepath else {
            return
        }
        let panel = NSSavePanel.init()
        panel.title = title
        panel.message = "设置保存路径"
        panel.allowsOtherFileTypes = true;
        panel.allowedFileTypes = fileTypes
        panel.isExtensionHidden = false
        panel.canCreateDirectories = true
        panel.level = NSWindow.Level.init(21)
        panel.begin { (response) in
            if response == .OK {
                try? FileManager.default.copyItem(atPath: path, toPath: panel.url?.path ?? "")
            }
        }
    }
    
    // 每日切换
    @objc private func dailyWallpaper(_ item: NSMenuItem) {
        if item.state == .off {
            item.state = .on
            PKDataManager.shared.isDaily = true
        } else {
            PKDataManager.shared.isDaily = false
            item.state = .off
        }
    }
    
    // 显示图标
    @objc private func showDesktopIcon(_ item: NSMenuItem) {
        PKDataManager.shared.iconStatus = .show
        // 选择图标显示状态
        let hideItem = menu.items.filter { $0.tag == PKConfig.getTag(.hideIcon) }.first
        hideItem?.state = .off
        item.state = .on
        
        // 设置playerWindow level 以显示图标
        let window = NSApp.windows.filter { $0 is PKPlayerWindow }.first
        window?.level = NSWindow.Level(rawValue: NSWindow.Level.RawValue(CGWindowLevelForKey(.desktopWindow) - 1))
    }
    
    // 隐藏桌面图标
    @objc private func hideDesktopIcon(_ item: NSMenuItem) {
        PKDataManager.shared.iconStatus = .hide
        // 选择图标显示状态
        let showItem = menu.items.filter { $0.tag == PKConfig.getTag(.showIcon) }.first
        showItem?.state = .off
        item.state = .on
        
        // 设置playerWindow level 以隐藏图标
        let window = NSApp.windows.filter { $0 is PKPlayerWindow }.first
        window?.level = NSWindow.Level(rawValue: NSWindow.Level.RawValue(CGWindowLevelForKey(.backstopMenu)))
    }
    
    // 配置启动项
    @objc private func startLoad(_ item: NSMenuItem) {
        if item.state == .off {
            item.state = .on
            PKDataManager.shared.isStartUp = true
        } else {
            item.state = .off
            PKDataManager.shared.isStartUp = false
        }
        let helperAppIdentifier = PKConfig.helperBundleIdentifier
        let success = SMLoginItemSetEnabled(helperAppIdentifier as CFString, PKDataManager.shared.isStartUp)
        if success {
            print("启动项配置成功: ", PKDataManager.shared.isStartUp)
        } else {
            print("启动项配置失败")
        }
    }
    
    @objc private func cleanCache() {
        PKDataManager.shared.cleanCache()
    }
    
    // 帮助
    @objc private func helpDoc() {
        guard let url = URL.init(string: "https://github.com/liyb93/PaperKite/wiki/%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E") else {
            return
        }
        NSWorkspace.shared.open(url)
    }
    
    // 关于我们
    @objc private func aboutUs() {
        NSApp.orderFrontStandardAboutPanel(nil)
    }
    
    // 反馈
    @objc private func issueFeedback() {
        guard let url = URL.init(string: "https://github.com/liyb93/PaperKite/issues") else {
            return
        }
        NSWorkspace.shared.open(url)
    }
    
    // 退出
    @objc private func exitApp() {
        NSApp.terminate(nil)
    }

}

