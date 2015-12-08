//
//  SDLRadioState.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

@interface SDLRadioState : SDLEnum

+ (SDLRadioState *)valueOf:(NSString *)value;
+ (NSArray *)values;

+ (SDLRadioState *)ACQUIRING;
+ (SDLRadioState *)ACQUIRED;
+ (SDLRadioState *)MULTICAST;
+ (SDLRadioState *)NOT_FOUND;

@end
