//  SDLAbstractProtocol.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLProtocol.h"
#import "SDLTransport.h"
#import "SDLProtocolListener.h"


@interface SDLAbstractProtocol : NSObject<SDLProtocol>

@property (strong) NSString *debugConsoleGroupName;
@property (strong) id<SDLTransport> transport;
@property (weak) id<SDLProtocolListener> protocolDelegate;

@end
