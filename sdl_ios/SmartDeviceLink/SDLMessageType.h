//
//  SDLMessageType.h
//  SmartDeviceLink
//
//  Created by Militello, Kevin (K.) on 12/18/14.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <SmartDeviceLink/SmartDeviceLink.h>

@interface SDLMessageType : SDLEnum

+(SDLMessageType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLMessageType*) UNDEFINED;
+(SDLMessageType*) BULK;
+(SDLMessageType*) RPC;

@end
