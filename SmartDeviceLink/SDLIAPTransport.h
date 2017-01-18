//  SDLIAPTransport.h
//

#import <ExternalAccessory/ExternalAccessory.h>

#import "SDLAbstractTransport.h"
#import "SDLIAPSessionDelegate.h"


@interface SDLIAPTransport : SDLAbstractTransport <SDLIAPSessionDelegate>

@property (strong, nonatomic) SDLIAPSession *controlSession;
@property (strong, nonatomic) SDLIAPSession *session;

@end
