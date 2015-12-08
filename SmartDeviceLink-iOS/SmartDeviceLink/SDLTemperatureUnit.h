//
//  SDLTemperatureUnit.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLTemperatureUnit : SDLEnum

+ (SDLTemperatureUnit *)valueOf:(NSString *)value;
+ (NSArray *)values;

+ (SDLTemperatureUnit *)KELVIN;
+ (SDLTemperatureUnit *)FAHRENHEIT;
+ (SDLTemperatureUnit *)CELSIUS;

@end

NS_ASSUME_NONNULL_END
