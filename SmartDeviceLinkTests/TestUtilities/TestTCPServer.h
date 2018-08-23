//
//  TestTCPServer.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/07/27.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Delegate to receive various events from the test TCP server
 */
@protocol TestTCPServerDelegate
- (void)onClientConnected;
- (void)onClientDataReceived:(NSData *)data;
- (void)onClientShutdown;
- (void)onClientError;
@end

@interface TestTCPServer : NSObject

/**
 *  Sets up a TCP server that listens on specified host and port
 *
 *  Note that this server cannot accept more than one connections from client(s).
 *
 *  @param hostName     Host name that the server will listen on
 *  @param portNumber   TCP port number of the server
 *  @return             YES when initialization is successful, NO otherwise
 */
- (BOOL)setup:(NSString *)hostName port:(NSString *)port;

/**
 *  Shuts down the server, forcefully closing client connection
 *
 *  @return YES when the server is successfully stopped, NO otherwise
 */
- (BOOL)teardown;

/**
 *  Asynchronously sends data to connected client
 *
 *  @param  data Data to send
 */
- (void)send:(NSData *)data;

/**
 *  Gracefully shuts down the connection between client.
 *
 *  This method triggers shutdown(SHUT_WR) which is to notify that the server does not have any more data to send.
 *
 *  @return YES if shutdown process is succeeded, NO if it's failed or client is not connected
 */
- (BOOL)shutdownClient;

/**
 *  The delegate to receive server events
 */
@property (nullable, nonatomic, weak) id<TestTCPServerDelegate> delegate;

/**
 *  Configure this flag to YES to enable SO_REUSEADDR option
 */
@property (nonatomic, assign) BOOL enableSOReuseAddr;

@end

NS_ASSUME_NONNULL_END
