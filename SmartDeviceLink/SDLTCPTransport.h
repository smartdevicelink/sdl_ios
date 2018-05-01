//  SDLTCPTransport.h
//

#import "SDLTransportType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTCPTransport : NSObject <SDLTransportType> {
    _Nullable CFSocketRef socket;
}

- (instancetype)initWithHostName:(NSString *)hostName portNumber:(NSString *)portNumber;

@property (strong, nonatomic) NSString *hostName;
@property (strong, nonatomic) NSString *portNumber;
@property (nullable, weak, nonatomic) id<SDLTransportDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
