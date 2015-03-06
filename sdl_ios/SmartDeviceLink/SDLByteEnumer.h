//
//  SDLByteEnumer.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDLByteEnumer : NSObject

-(instancetype)initWithValue:(Byte)value name:(NSString*)name;

+(SDLByteEnumer*)get:(NSArray*)theList value:(Byte)value;

@property (strong, nonatomic, readonly) NSString* name;
@property (nonatomic) Byte value;

@end
