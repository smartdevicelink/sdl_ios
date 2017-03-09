//
//  SDLLog.swift
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import Foundation

import SmartDeviceLink


/// You may use this class or the below functions for convenience logging in Swift 3 projects.
/// It would be used like so:
///
/// ```
/// let log = SDLLog.self
/// log.e("Test something \(NSDate())")
/// ```
public class SDLLog {
    /// Log a verbose message through SDL's custom logging framework.
    ///
    /// - Parameters:
    ///   - message: The message to be logged.
    ///   - file: The file the log is coming from, you should probably leave this as the default.
    ///   - function: The function the log is coming from, you should probably leave this as the default.
    ///   - line: The line the log is coming from, you should probably leave this as the default.
    public class func v(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SDLLogManager.log(with: .verbose, file: file, functionName: function, line: line, message: "\(message())")
    }

    /// Log a debug message through SDL's custom logging framework.
    ///
    /// - Parameters:
    ///   - message: The message to be logged.
    ///   - file: The file the log is coming from, you should probably leave this as the default.
    ///   - function: The function the log is coming from, you should probably leave this as the default.
    ///   - line: The line the log is coming from, you should probably leave this as the default.
    public class func d(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SDLLogManager.log(with: .debug, file: file, functionName: function, line: line, message: "\(message())")
    }

    /// Log a warning message through SDL's custom logging framework.
    ///
    /// - Parameters:
    ///   - message: The message to be logged.
    ///   - file: The file the log is coming from, you should probably leave this as the default.
    ///   - function: The function the log is coming from, you should probably leave this as the default.
    ///   - line: The line the log is coming from, you should probably leave this as the default.
    public class func w(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SDLLogManager.log(with: .warning, file: file, functionName: function, line: line, message: "\(message())")
    }

    /// Log an error message through SDL's custom logging framework.
    ///
    /// - Parameters:
    ///   - message: The message to be logged.
    ///   - file: The file the log is coming from, you should probably leave this as the default.
    ///   - function: The function the log is coming from, you should probably leave this as the default.
    ///   - line: The line the log is coming from, you should probably leave this as the default.
    public class func e(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SDLLogManager.log(with: .error, file: file, functionName: function, line: line, message: "\(message())")
    }
}

/// Log a verbose message through SDL's custom logging framework.
///
/// - Parameters:
///   - message: The message to be logged.
///   - file: The file the log is coming from, you should probably leave this as the default.
///   - function: The function the log is coming from, you should probably leave this as the default.
///   - line: The line the log is coming from, you should probably leave this as the default.
public func SDLV(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    SDLLogManager.log(with: .verbose, file: file, functionName: function, line: line, message: "\(message())")
}

/// Log a debug message through SDL's custom logging framework.
///
/// - Parameters:
///   - message: The message to be logged.
///   - file: The file the log is coming from, you should probably leave this as the default.
///   - function: The function the log is coming from, you should probably leave this as the default.
///   - line: The line the log is coming from, you should probably leave this as the default.
public func SDLD(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    SDLLogManager.log(with: .debug, file: file, functionName: function, line: line, message: "\(message())")
}

/// Log a warning message through SDL's custom logging framework.
///
/// - Parameters:
///   - message: The message to be logged.
///   - file: The file the log is coming from, you should probably leave this as the default.
///   - function: The function the log is coming from, you should probably leave this as the default.
///   - line: The line the log is coming from, you should probably leave this as the default.
public func SDLW(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    SDLLogManager.log(with: .warning, file: file, functionName: function, line: line, message: "\(message())")
}

/// Log an error message through SDL's custom logging framework.
///
/// - Parameters:
///   - message: The message to be logged.
///   - file: The file the log is coming from, you should probably leave this as the default.
///   - function: The function the log is coming from, you should probably leave this as the default.
///   - line: The line the log is coming from, you should probably leave this as the default.
public func SDLE(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    SDLLogManager.log(with: .error, file: file, functionName: function, line: line, message: "\(message())")
}
