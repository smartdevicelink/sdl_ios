//
//  SDLDefrostZone.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLDefrostZone : SDLEnum

+ (SDLDefrostZone *)valueOf:(NSString *)value;
+ (NSArray *)values;

+ (SDLDefrostZone *)FRONT;
+ (SDLDefrostZone *)REAR;
+ (SDLDefrostZone *)ALL;

@end

NS_ASSUME_NONNULL_END
