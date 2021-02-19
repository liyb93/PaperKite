//
//  File Name:  PKAlert.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/9 18:12
//

import Cocoa

class PKAlert: NSObject {
    static func show(_ title: String, message: String? = nil, icon: NSImage? = nil, handler:((NSApplication.ModalResponse)->())? = nil) {
        let alert = NSAlert.init()
        alert.messageText = title
        alert.informativeText = message ?? ""
        if let ic = icon {
            alert.icon = ic
        }
        if let window = NSApp.windows.filter({$0 is PKAlertWindow}).first {
            alert.beginSheetModal(for: window) { (response) in
                window.makeKeyAndOrderFront(self)
                NSApp.activate(ignoringOtherApps: true)
                handler?(response)
            }
        } else {
            let windowController = PKAlertWindowController.showWindow()
            if let window = windowController.window {
                alert.beginSheetModal(for: window) { (response) in
                    window.makeKeyAndOrderFront(self)
                    NSApp.activate(ignoringOtherApps: true)
                    handler?(response)
                }
            }
        }
    }
}
