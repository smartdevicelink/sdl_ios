//  SDLTCPTransport.h
//

#import "SDLTransportType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTCPTransport : NSObject <SDLTransportType, NSStreamDelegate>

/**
 *  Convenience init
 *
 *  @param hostName     The host name of Core
 *  @param portNumber   The port number of Core
 *  @return             A SDLTCPTransport object
 */
- (instancetype)initWithHostName:(NSString *)hostName portNumber:(NSString *)portNumber;

/**
 *  The host name of Core
 */
@property (strong, nonatomic) NSString *hostName;

/**
 *  The port number of Core
 */
@property (strong, nonatomic) NSString *portNumber;

/**
 *  The subscribed listener
 */
@property (nullable, weak, nonatomic) id<SDLTransportDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
