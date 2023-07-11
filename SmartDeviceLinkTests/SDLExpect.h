//
//  SDLExpect.h
//  SmartDeviceLinkTests
//
//  Created by Frank Elias on 6/13/23.
//  Copyright © 2023 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ ExpectBlock)(void);

@interface SDLExpect : NSObject

#define sdlExp(timeout, expectBlock) [SDLExpect SDLExpectWithTimeout timeout:timeout expectBlock:expectBlock)]

+ (void)SDLExpectWithTimeout:(NSTimeInterval)timeout expectBlock:(ExpectBlock)expectBlock;
+ (BOOL)getVerifiedVal:(BOOL)value;
+ (int)timeout;

@end

NS_ASSUME_NONNULL_END
