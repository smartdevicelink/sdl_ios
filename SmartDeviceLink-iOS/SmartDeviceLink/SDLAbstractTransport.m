//  SDLAbstractTransport.m

#import "SDLAbstractTransport.h"

@implementation SDLAbstractTransport

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)connect {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)disconnect {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)sendData:(NSData *)dataToSend {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)dispose {
    [self doesNotRecognizeSelector:_cmd];
}

- (double)retryDelay {
    [self doesNotRecognizeSelector:_cmd];
    return 0.0;
}

- (void)notifyTransportConnected {
    if ([self.delegate conformsToProtocol:@protocol(SDLTransportDelegate)]) {
        [self.delegate onTransportConnected];
    }
}

- (void)notifyTransportDisconnected {
    if ([self.delegate conformsToProtocol:@protocol(SDLTransportDelegate)]) {
        [self.delegate onTransportDisconnected];
    }
}

- (void)handleDataReceivedFromTransport:(NSData *)receivedData {
    if ([self.delegate conformsToProtocol:@protocol(SDLTransportDelegate)]) {
        [self.delegate onDataReceived:receivedData];
    }
}

@end