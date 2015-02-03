//  SDLVrHelpItem.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLImage.h>

@interface SDLVrHelpItem : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* text;
@property(strong) SDLImage* image;
@property(strong) NSNumber* position;

@end
