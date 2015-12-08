//
//  SDLModuleType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLModuleType : SDLEnum

+ (SDLModuleType *)valueOf:(NSString *)value;

+ (NSArray *)values;

+ (SDLModuleType *)CLIMATE;

+ (SDLModuleType *)RADIO;

@end

NS_ASSUME_NONNULL_END
