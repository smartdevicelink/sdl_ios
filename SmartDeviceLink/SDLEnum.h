//  SDLEnum.h
//


#import <Foundation/Foundation.h>
#import "SDLMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString* SDLEnum SDL_SWIFT_ENUM;

@interface NSString (Enum)

- (BOOL)isEqualToEnum:(SDLEnum)enumObj;

@end

NS_ASSUME_NONNULL_END
