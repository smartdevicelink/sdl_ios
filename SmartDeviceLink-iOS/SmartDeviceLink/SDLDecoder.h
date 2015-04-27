//  SDLDecoder.h
//


@import Foundation;

@protocol SDLDecoder <NSObject>

-(NSDictionary*) decode:(NSData*) msgBytes;

@end
