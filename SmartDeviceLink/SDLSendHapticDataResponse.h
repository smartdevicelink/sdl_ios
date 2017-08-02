//
//  SDLSendHapticDataResponse.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

@interface SDLSendHapticDataResponse : SDLRPCResponse

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
