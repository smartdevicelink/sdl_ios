//  SDLAbstractTransport.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLTransportDelegate.h"

@interface SDLAbstractTransport : NSObject

@property (weak) id<SDLTransportDelegate> delegate;
@property (strong) NSString *debugConsoleGroupName;

- (instancetype)init;
- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;
- (void)dispose;
- (double)retryDelay;

@end
