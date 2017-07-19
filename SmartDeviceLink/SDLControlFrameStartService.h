//
//  SDLControlFrameStartService.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/18/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <SmartDeviceLink/SmartDeviceLink.h>

@interface SDLControlFrameStartService : SDLProtocolMessage

@property (copy, nonatomic, readonly) NSString *versionNumber;

- (instancetype)initWithMajorVersion:(int32_t)majorVersion minorVersion:(int32_t)minorVersion patchVersion:(int32_t)patchVersion;

@end
