//
//  SDLGlobals.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SDL_SYSTEM_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)
#define SDL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending)
#define BLOCK_RETURN return

@interface SDLGlobals : NSObject

@property (assign, nonatomic, readonly) NSUInteger protocolVersion;
@property (assign, nonatomic, readonly) NSUInteger maxMTUSize;
@property (assign, nonatomic) NSUInteger maxHeadUnitVersion;

+ (instancetype)sharedGlobals;

@end

NS_ASSUME_NONNULL_END
