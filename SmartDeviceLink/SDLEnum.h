//  SDLEnum.h
//


#import <Foundation/Foundation.h>
#import "SDLMacros.h"

NS_ASSUME_NONNULL_BEGIN

/// NSString SDLEnum typedef
typedef NSString* SDLEnum SDL_SWIFT_ENUM;

/// Compares two enums for equivalents
@interface NSString (SDLEnum)

/**
 *  Returns whether or not two enums are equal.
 *
 *  @param enumObj  A SDLEnum object
 *  @return         YES if the two enums are equal. NO if not.
 */
- (BOOL)isEqualToEnum:(SDLEnum)enumObj;

@end

NS_ASSUME_NONNULL_END
