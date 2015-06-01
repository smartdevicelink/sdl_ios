//
//  SDLRPCOnStream.m
//  SmartDeviceLink
//
//  Created by CHDSEZ318988DADM on 07/05/15.
//  Copyright (c) 2015 FMC. All rights reserved.
//

#import "SDLRPCOnStream.h"

@implementation SDLRPCOnStream

-(id) initWithFileName:(NSString*)fileName fileSize:(NSNumber*)size bytesSent:(NSNumber*)bytes correlationID:(NSNumber*)correlationID{
    if (self = [super init]){
        [self setFileName:fileName];
        [self setTotalSize:size];
        [self setNumberOfBytesSent:bytes];
        [self setIsSuccess:0];
        [self setInitialCorrelationID:correlationID];
    }
    return self;
}

@end
