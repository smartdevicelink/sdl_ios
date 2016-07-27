//  SDLJsonDecoder.h
//

#import <Foundation/Foundation.h>

#import "SDLDecoder.h"


@interface SDLJsonDecoder : NSObject <SDLDecoder> {
}

+ (NSObject<SDLDecoder> *)instance;

@end
