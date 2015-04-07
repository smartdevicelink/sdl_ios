//  SDLIAPTransport.h
//

@import ExternalAccessory;
#import "SDLAbstractTransport.h"


@interface SDLIAPTransport : SDLAbstractTransport <NSStreamDelegate> {}

@property (assign) BOOL forceLegacy;

@end
