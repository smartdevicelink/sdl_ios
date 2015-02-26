//  SDLIAPTransport.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLIAPSessionDelegate.h"
#import "SDLAbstractTransport.h"
#import "SDLIAPSession.h"

@interface SDLIAPTransport : SDLAbstractTransport<SDLIAPSessionDelegate>

@property (strong, atomic) SDLIAPSession *controlSession;
@property (strong, atomic) SDLIAPSession *session;

- (instancetype)init;

@end
