//  SDLDecoder.h
//


@import Foundation;

@protocol SDLDecoder

- (NSDictionary *)decode:(NSData *)msgBytes;

@end
