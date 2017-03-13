//
//  SDLEnum.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 3/13/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSString (SDLEnum)

- (BOOL)isEqualToEnum:(SDLEnum)enumObj {
    return [self isEqualToString:enumObj];
}

@end

NS_ASSUME_NONNULL_END
