//
//  SDLRadioBand.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLRadioBand : SDLEnum

+ (SDLRadioBand *)valueOf:(NSString *)value;

+ (NSArray *)values;

+ (SDLRadioBand *)AM;

+ (SDLRadioBand *)FM;

+ (SDLRadioBand *)XM;

@end

NS_ASSUME_NONNULL_END
