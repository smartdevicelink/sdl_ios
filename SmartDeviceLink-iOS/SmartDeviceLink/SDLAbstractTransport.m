//  SDLAbstractTransport.m

#import "SDLAbstractTransport.h"
#import "SDLBaseTransportConfig.h"

@interface SDLAbstractTransport()

@property (nonatomic, getter=isConnected) BOOL connected;

@end

@implementation SDLAbstractTransport

- (instancetype)init {
    if (self = [super init]) {

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

@end
