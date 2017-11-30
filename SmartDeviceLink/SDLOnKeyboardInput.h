//  SDLOnKeyboardInput.h
//

#import "SDLRPCNotification.h"

#import "SDLKeyboardEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnKeyboardInput : SDLRPCNotification

@property (strong, nonatomic) SDLKeyboardEvent event;
@property (nullable, strong, nonatomic) NSString *data;

@end

NS_ASSUME_NONNULL_END
