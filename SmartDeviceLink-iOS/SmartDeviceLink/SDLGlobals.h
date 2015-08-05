//
//  SDLGlobals.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDLGlobals : NSObject

@property (assign, nonatomic) NSUInteger protocolVersion;
@property (assign, nonatomic, readonly) NSUInteger maxMTUSize;

+ (instancetype)globals;

@end
