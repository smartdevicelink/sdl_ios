//
//  SDLLogMacros.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Macros

#pragma mark - General Macros
#define SDLLOG_FILE   [[[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent] stringByDeletingPathExtension]
#define SDLLOG_FUNC   [NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]

#pragma mark Debug Logs

#if DEBUG

#define SDLLogV(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelVerbose fileName:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];
#define SDLLogD(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelDebug fileName:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];

#else

#define SDLLogV(msg, ...)
#define SDLLogD(msg, ...)

#endif


#pragma mark Release Logs

#define SDLLogW(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelWarning fileName:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];
#define SDLLogE(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelError fileName:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];
