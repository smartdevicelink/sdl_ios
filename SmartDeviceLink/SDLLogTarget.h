//
//  SDLLogTarget.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLogModel;


NS_ASSUME_NONNULL_BEGIN

@protocol SDLLogTarget <NSObject>

+ (id<SDLLogTarget>)logger;
- (BOOL)setupLogger;
- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog;
- (void)teardownLogger;

@end

NS_ASSUME_NONNULL_END
