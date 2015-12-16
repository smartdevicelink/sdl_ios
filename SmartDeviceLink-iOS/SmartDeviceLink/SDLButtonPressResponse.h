//
//  SDLRCButtonPressResponse.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

@interface SDLButtonPressResponse : SDLRPCResponse

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
