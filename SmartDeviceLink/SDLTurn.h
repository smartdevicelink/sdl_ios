//  SDLTurn.h
//

#import "SDLRPCMessage.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLTurn : SDLRPCStruct

- (instancetype)initWithNavigationText:(nullable NSString *)navigationText turnIcon:(nullable SDLImage *)icon;

@property (strong, nonatomic, nullable) NSString *navigationText;
@property (strong, nonatomic, nullable) SDLImage *turnIcon;

@end

NS_ASSUME_NONNULL_END
