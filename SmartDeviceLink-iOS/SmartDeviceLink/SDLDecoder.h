//  SDLDecoder.h
//


#import <Foundation/Foundation.h>

@protocol SDLDecoder <NSObject>

- (NSDictionary *)decode:(NSData *)msgBytes;

@end
