//
//  SDLRPCOnStream.h
//  SmartDeviceLink
//
//  Created by CHDSEZ318988DADM on 07/05/15.
//  Copyright (c) 2015 FMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDLRPCOnStream : NSObject

@property (strong) NSNumber* numberOfBytesSent;
@property (strong) NSNumber* totalSize;
@property (strong) NSString* fileName;
@property (strong) NSNumber* initialCorrelationID;
@property  NSInteger isSuccess;

-(id) initWithFileName:(NSString*)fileName fileSize:(NSNumber*)size bytesSent:(NSNumber*)bytes correlationID:(NSNumber*)correlationID;
@end
