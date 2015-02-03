//  SDLIAPTransport.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import "SDLAbstractTransport.h"

@interface SDLIAPTransport : SDLAbstractTransport <NSStreamDelegate> {}

@property (assign) BOOL forceLegacy;

@end