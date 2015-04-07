//  SDLAbstractTransport.m
//  SDLAbstractTransport.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAbstractTransport.h"
#import "SDLBaseTransportConfig.h"

@interface SDLAbstractTransport()

@property (nonatomic, getter=isConnected) BOOL connected;

@end

@implementation SDLAbstractTransport

- (instancetype) initWithEndpoint:(NSString*) endpoint endpointParam:(NSString*) param {
    if (self = [super init]) {
        _endpointName = endpoint;
        _endpointParam = param;
        _debugConsoleGroupName = @"default";
    }
    return self;
}

-(instancetype)initWithTransportConfig:(SDLBaseTransportConfig*)transportConfig delegate:(id<SDLTransportDelegate>)delegate{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)notifyTransportConnected {
    self.connected = YES;
    [self.delegate onTransportConnected];
}

- (void)notifyTransportDisconnected {
    self.connected = YES;
    [self.delegate onTransportDisconnected];
}

- (void)handleDataReceivedFromTransport:(NSData *)receivedData {
    [self.delegate onDataReceived:receivedData];
}


#pragma mark SDLTransport Implementation
- (void)connect {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)disconnect {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)sendData:(NSData *)dataToSend {
	[self doesNotRecognizeSelector:_cmd];
}

@end
