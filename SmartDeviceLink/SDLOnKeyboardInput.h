//  SDLOnKeyboardInput.h
//

#import "SDLRPCNotification.h"

#import "SDLKeyboardEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnKeyboardInput : SDLRPCNotification

@property (strong) SDLKeyboardEvent event;
@property (nullable, strong) NSString *data;

@end

NS_ASSUME_NONNULL_END
