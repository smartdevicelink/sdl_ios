//  SDLTransport.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLTransportDelegate.h"

@protocol SDLTransport

@property (weak) id<SDLTransportDelegate> delegate;

- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;

@end