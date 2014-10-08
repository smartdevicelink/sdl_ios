//  SDLAbstractTransport.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLTransport.h"
#import "SDLTransportDelegate.h"

@interface SDLAbstractTransport : NSObject<SDLTransport>

@property (weak) id<SDLTransportDelegate> delegate;
@property (strong) NSString *debugConsoleGroupName;
@property (strong, readonly) NSString* endpointName;
@property (strong, readonly) NSString* endpointParam;

- (id) initWithEndpoint:(NSString*) endpoint endpointParam:(NSString*) endointParam;

- (void)notifyTransportConnected;
- (void)notifyTransportDisconnected;
- (void)handleDataReceivedFromTransport:(NSData *)receivedData;

@end
