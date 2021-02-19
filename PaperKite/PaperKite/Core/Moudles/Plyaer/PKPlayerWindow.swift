//
//  File Name:  PKPlayerWindow.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/9 17:47
//

import Cocoa

class PKPlayerWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        level = NSWindow.Level(rawValue: NSWindow.Level.RawValue(CGWindowLevelForKey(.desktopWindow) - 1))
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        backgroundColor = .clear
        isOpaque = false
    }
    
    override var canBecomeKey: Bool {
        return false
    }
    
    override var canBecomeMain: Bool {
        return false
    }
}
