//
//  File Name:  String+PaperKite.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/11 16:10
//

import Foundation
import CommonCrypto

extension String {
    func md5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: length)
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        // 去除斜杠
        var result = digestData.base64EncodedString()
        while result.contains("/") {
            result = result.replacingOccurrences(of: "/", with: "")
        }
        return result
    }
}
