//  SDLTouchType.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLTouchType : SDLEnum {}

+(SDLTouchType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLTouchType*) BEGIN;
+(SDLTouchType*) MOVE;
+(SDLTouchType*) END;

@end
