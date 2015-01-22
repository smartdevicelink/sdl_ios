//  SDLIAPTransport.h
//
//  

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import "SDLAbstractTransport.h"

@interface SDLIAPTransport : SDLAbstractTransport <NSStreamDelegate> {}

@property (assign) BOOL forceLegacy;

- (void)unregister;

@end
