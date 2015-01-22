//  SDLTCPTransport.h
//
//  

#import <Foundation/Foundation.h>
#import "SDLAbstractTransport.h"

@interface SDLTCPTransport : SDLAbstractTransport {
	CFSocketRef socket;
}

@end
