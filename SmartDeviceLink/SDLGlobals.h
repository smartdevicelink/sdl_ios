//
//  SDLGlobals.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SDL_SYSTEM_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)
#define BLOCK_RETURN return

extern NSString *const maxProxyProtocolVersion;

extern NSUInteger const SDLDefaultMTUSize;
extern NSUInteger const SDLV1MTUSize;
extern NSUInteger const SDLV3MTUSize;

@interface SDLGlobals : NSObject

@property (strong, nonatomic, readonly) NSString *protocolVersion;
@property (assign, nonatomic, readonly) NSInteger majorProtocolVersion;
@property (assign, nonatomic) NSUInteger maxMTUSize;
@property (strong, nonatomic) NSString *maxHeadUnitVersion;

+ (instancetype)globals;

@end
