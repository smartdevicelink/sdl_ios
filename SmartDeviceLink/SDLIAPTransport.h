//  SDLIAPTransport.h
//

#import <ExternalAccessory/ExternalAccessory.h>

#import "SDLAbstractTransport.h"
#import "SDLIAPSessionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPTransport : SDLAbstractTransport <SDLIAPSessionDelegate>

@property (nullable, strong, atomic) SDLIAPSession *controlSession;
@property (nullable, strong, atomic) SDLIAPSession *session;

@end

NS_ASSUME_NONNULL_END
