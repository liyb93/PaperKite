//
//  File Name:  PKPlayerWindowController.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/9 17:46
//

import Cocoa

class PKPlayerWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        let w = NSScreen.main?.frame.width ?? 0
        let h = NSScreen.main?.frame.height ?? 0
        window?.setFrame(CGRect.init(x: 0, y: 0, width: w, height: h), display: true)
    }

}
