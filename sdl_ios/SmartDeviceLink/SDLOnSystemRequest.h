//  SDLOnSystemRequest.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLRequestType.h>
#import <SmartDeviceLink/SDLFileType.h>

@interface SDLOnSystemRequest : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLRequestType* requestType;
@property(strong) NSString* url;
@property(strong) NSNumber* timeout;
@property(strong) SDLFileType* fileType;
@property(strong) NSNumber* offset;
@property(strong) NSNumber* length;

@end
