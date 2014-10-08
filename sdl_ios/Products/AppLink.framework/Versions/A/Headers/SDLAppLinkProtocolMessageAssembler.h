//  SDLAppLinkProtocolMessageAssembler.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLAppLinkProtocolMessage.h"

typedef void(^AppLinkMessageAssemblyCompletionHandler)(BOOL done, SDLAppLinkProtocolMessage *assembledMessage);


@interface SDLAppLinkProtocolMessageAssembler : NSObject

@property (assign, readonly) UInt8 sessionID;
@property (assign) UInt32 frameCount; // number of consecutive frames required for reassembly
@property (assign) UInt32 expectedBytes;
@property (strong) NSMutableDictionary *parts;

- (id)initWithSessionID:(UInt8)sessionID;
- (void)handleMessage:(SDLAppLinkProtocolMessage *)message withCompletionHandler:(AppLinkMessageAssemblyCompletionHandler)completionHandler;

@end
