//
//  TextValidator.swift
//  SmartDeviceLink
//
//  Created by Nicole on 7/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation

class TextValidator {
    private static let validEnglishCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 :."

    class func validateText(_ text: String, length: Int) -> String {
        if text.isEmpty { return text }
        let filteredText = filterUnsupportedCharacters(text)
        let condensedString = filteredText.condenseWhitespace
        let truncatedString = condensedString.trunc(length: length)
        return truncatedString
    }

    private class func filterUnsupportedCharacters(_ text:String) -> String {
        return String(text.filter { validEnglishCharacters.contains($0) } )
    }
}

extension String {
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }

    var condenseWhitespace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
