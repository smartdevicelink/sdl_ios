//  SDLJsonDecoder.h
//

@import Foundation;

#import "SDLDecoder.h"


@interface SDLJsonDecoder : NSObject<SDLDecoder> {}

+(NSObject<SDLDecoder>*) instance;

@end
