//
//  SDLLogConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLogModel;

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^SDLLogFilterBlock)(SDLLogModel *log);

typedef NS_OPTIONS(NSUInteger, SDLLogFlag) {
    SDLLogFlagVerbose = 1 << 0,
    SDLLogFlagDebug = 1 << 1,
    SDLLogFlagWarning = 1 << 2,
    SDLLogFlagError = 1 << 3
};

typedef NS_ENUM(NSInteger, SDLLogLevel) {
    SDLLogLevelDefault = -1,
    SDLLogLevelOff = 0,
    SDLLogLevelError = SDLLogFlagError,
    SDLLogLevelWarning = (SDLLogFlagError | SDLLogFlagWarning),
    SDLLogLevelDebug = (SDLLogFlagWarning | SDLLogFlagDebug),
    SDLLogLevelVerbose = (SDLLogFlagDebug | SDLLogFlagVerbose)
};

typedef NS_ENUM(NSUInteger, SDLLogFormatType) {
    SDLLogFormatTypeSimple,
    SDLLogFormatTypeDefault,
    SDLLogFormatTypeDetailed,
};

NS_ASSUME_NONNULL_END
