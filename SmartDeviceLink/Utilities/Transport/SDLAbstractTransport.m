//  SDLAbstractTransport.m

#import "SDLAbstractTransport.h"

NS_ASSUME_NONNULL_BEGIN

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

- (double)retryDelay {
    [self doesNotRecognizeSelector:_cmd];
    return 0.0;
}

@end

NS_ASSUME_NONNULL_END
