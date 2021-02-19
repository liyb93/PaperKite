//
//  File Name:  PKAlertWindowController.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/9 17:51
//

import Cocoa

class PKAlertWindowController: NSWindowController {

    class func showWindow() -> PKAlertWindowController {
        let windowController = PKAlertWindowController.init()
        let window = PKAlertWindow.init(contentRect: NSScreen.main?.frame ?? .zero, styleMask: [.borderless], backing: .buffered, defer: true)
        windowController.window = window
        windowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        return windowController
    }
    
    init() {
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
