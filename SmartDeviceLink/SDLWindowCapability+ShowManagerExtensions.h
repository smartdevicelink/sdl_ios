//
//  SDLWindowCapability+ShowManagerExtensions.h
//  SmartDeviceLink
//
//  Created by Kujtim Shala (Ford) on 13.09.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLImageFieldName.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLWindowCapability (ShowManagerExtensions)

@property (assign, nonatomic, readonly) NSUInteger maxNumberOfMainFieldLines;

- (BOOL)hasTextFieldOfName:(SDLTextFieldName)name;
- (BOOL)hasImageFieldOfName:(SDLImageFieldName)name;

@end

NS_ASSUME_NONNULL_END
