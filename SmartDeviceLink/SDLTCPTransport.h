//  SDLTCPTransport.h
//

#import "SDLAbstractTransport.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTCPTransport : SDLAbstractTransport {
    _Nullable CFSocketRef socket;
}

@property (strong, atomic) NSString *hostName;
@property (strong, atomic) NSString *portNumber;

@end

NS_ASSUME_NONNULL_END
