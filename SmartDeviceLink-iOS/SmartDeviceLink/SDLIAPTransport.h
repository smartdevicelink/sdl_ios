//  SDLIAPTransport.h
//



#import <ExternalAccessory/ExternalAccessory.h>
#import "SDLAbstractTransport.h"
#import "SDLIAPSessionDelegate.h"

@class SDLIAPSession;

@interface SDLIAPTransport : SDLAbstractTransport <SDLIAPSessionDelegate>

@property (strong, atomic) SDLIAPSession *controlSession;
@property (strong, atomic) SDLIAPSession *session;

@end
