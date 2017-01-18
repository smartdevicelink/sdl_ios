//  SDLTCPTransport.h
//

#import "SDLAbstractTransport.h"

@interface SDLTCPTransport : SDLAbstractTransport {
    CFSocketRef socket;
}

@property (strong, nonatomic) NSString *hostName;
@property (strong, nonatomic) NSString *portNumber;

@end
