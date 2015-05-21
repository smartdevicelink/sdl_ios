//  SDLIAPTransport.h
//

@import ExternalAccessory;

#import "SDLAbstractTransport.h"
#import "SDLIAPSessionDelegate.h"


@interface SDLIAPTransport : SDLAbstractTransport <SDLIAPSessionDelegate>

@property (strong, atomic) SDLIAPSession *controlSession;
@property (strong, atomic) SDLIAPSession *session;

@end
