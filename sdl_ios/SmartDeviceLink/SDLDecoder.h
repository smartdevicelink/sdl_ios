//  SDLDecoder.h
//
// 

#import <Foundation/Foundation.h>

@protocol SDLDecoder

-(NSDictionary*) decode:(NSData*) msgBytes;

@end
