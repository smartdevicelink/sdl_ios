//  SDLOnEncodedSyncPData.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

@interface SDLOnEncodedSyncPData : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* data;
@property(strong) NSString* URL;
@property(strong) NSNumber* Timeout;

@end
