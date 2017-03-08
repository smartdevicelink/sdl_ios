//
//  NSNumber+NumberType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/19/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A decleration that this NSNumber contains an NSInteger.
 */
@protocol SDLInt
@end

/**
 *  A declaration that this NSNumber contains an NSUInteger.
 */
@protocol SDLUInt
@end

/**
 *  A declaration that this NSNumber contains a BOOL.
 */
@protocol SDLBool
@end

/**
 *  A declaration that this NSNumber contains a float.
 */
@protocol SDLFloat
@end

@interface NSNumber (NumberType) <SDLInt, SDLUInt, SDLBool, SDLFloat>

@end
