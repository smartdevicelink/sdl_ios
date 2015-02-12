//  SDLTCPTransport.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLAbstractTransport.h"

@interface SDLTCPTransport : SDLAbstractTransport {
    CFSocketRef socket;
}

@property (strong, atomic) NSString *hostName;
@property (strong, atomic) NSString *portNumber;

@end
