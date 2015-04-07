//  SDLTCPTransport.h
//

#import "SDLAbstractTransport.h"

@interface SDLTCPTransport : SDLAbstractTransport {
	CFSocketRef socket;
}

@end
