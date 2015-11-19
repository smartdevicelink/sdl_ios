//
//  NSNumber+NumberType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/19/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLInt
@end

@protocol SDLUInt
@end

@protocol SDLBool
@end

@protocol SDLFloat
@end

@interface NSNumber (NumberType) <SDLInt, SDLUInt, SDLBool, SDLFloat>

@end
