//  SDLEnum.h
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// NSString SDLEnum typedef
typedef NSString* SDLEnum NS_TYPED_ENUM;

/// Extensions to NSString specifically for SDL string enums
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
