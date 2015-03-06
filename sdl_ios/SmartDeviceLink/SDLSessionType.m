//
//  SDLSessionType.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLSessionType.h"

@implementation SDLSessionType

-(instancetype)initWithValue:(Byte)value name:(NSString*)name{
    return [super initWithValue:value name:name];
}

+(NSArray*)theList{
    return @[[SDLSessionType RPC],
             [SDLSessionType PCM],
             [SDLSessionType NAV],
             [SDLSessionType Bulk_Data],
             [SDLSessionType Heartbeat]];
}

+(SDLSessionType*)Heartbeat{
    //TODO: Is this referring to Android service? Does this still apply to iOS?
    return [[SDLSessionType alloc] initWithValue:0 name:@"Heartbeat_Service"];
}

+(SDLSessionType*)RPC{
    return [[SDLSessionType alloc] initWithValue:0x07 name:@"RPC"];
}

+(SDLSessionType*)PCM{
    return [[SDLSessionType alloc] initWithValue:0x0A name:@"PCM"];
}

+(SDLSessionType*)NAV{
    return [[SDLSessionType alloc] initWithValue:0x0B name:@"NAV"];
}

+(SDLSessionType*)Bulk_Data{
    return [[SDLSessionType alloc] initWithValue:0xF name:@"Bulk_Data"];
}

+(SDLSessionType*)valueOf:(Byte)passedButton{
    return (SDLSessionType*)[SDLByteEnumer get:[SDLSessionType theList] value:passedButton];
}

+(NSArray*)values{
    return [SDLSessionType theList];
}

@end
