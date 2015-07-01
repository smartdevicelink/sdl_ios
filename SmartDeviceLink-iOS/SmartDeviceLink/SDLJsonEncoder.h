//  SDLJsonEncoder.h
//

#import <Foundation/Foundation.h>

#import "SDLEncoder.h"


@interface SDLJsonEncoder : NSObject <SDLEncoder> {
}

+ (NSObject<SDLEncoder> *)instance;

@end
