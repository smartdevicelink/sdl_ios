//  SDLJsonDecoder.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLDecoder.h>

@interface SDLJsonDecoder : NSObject<SDLDecoder> {}

+(NSObject<SDLDecoder>*) instance;

@end
