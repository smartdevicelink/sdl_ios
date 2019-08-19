//  SDLEnum.h
//


#import <Foundation/Foundation.h>
#import "SDLEnumTypes.h"

NS_ASSUME_NONNULL_BEGIN

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
