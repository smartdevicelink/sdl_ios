//  SDLIAPTransport.h
//

#import <ExternalAccessory/ExternalAccessory.h>

#import "SDLAbstractTransport.h"
#import "SDLIAPSessionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPTransport : SDLAbstractTransport <SDLIAPSessionDelegate>

@property (nullable, strong, nonatomic) SDLIAPSession *controlSession;
@property (nullable, strong, nonatomic) SDLIAPSession *session;

@end

NS_ASSUME_NONNULL_END
