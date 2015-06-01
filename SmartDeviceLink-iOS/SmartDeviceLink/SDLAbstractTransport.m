//  SDLAbstractTransport.m

#import "SDLAbstractTransport.h"

#define DEFAULT_MTU 1500

@implementation SDLAbstractTransport

- (instancetype)init {
    if (self = [super init]) {
        _MTU = DEFAULT_MTU;
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

@end
