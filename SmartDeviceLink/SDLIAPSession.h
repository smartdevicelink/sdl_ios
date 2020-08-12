//
//  SDLIAPSession.h
//

#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface SDLIAPSession : NSObject <NSStreamDelegate>

/**
 *  The accessory with which to open a session.
 */
@property (nullable, strong, nonatomic, readonly) EAAccessory *accessory;

/**
 *  The session created between the app and the accessory.
 */
@property (nullable, strong, nonatomic, readonly) EASession *eaSession;

/**
 *  The unique protocol string used to create the session with the accessory.
 */
@property (nullable, strong, nonatomic, readonly) NSString *protocolString;

/**
 *  Returns whether or not both the input and output streams for the session are closed.
 */
@property (assign, readonly, getter=isStopped) BOOL stopped;

/**
 * The input stream for the session is open when a `NSStreamEventOpenCompleted` event is received for the input stream. The input stream is closed when the stream status is `NSStreamStatusClosed`.
 */
@property (nonatomic, assign) BOOL isInputStreamOpen;

/**
 * The output stream for the session is open when a `NSStreamEventOpenCompleted` event is received for the output stream. The output stream has been closed when the stream status is `NSStreamStatusClosed`.
 */
@property (nonatomic, assign) BOOL isOutputStreamOpen;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  Returns whether the session has open I/O streams.
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

/**
 *  Convenience initializer for setting an accessory and protocol string.
 *
 *  @param accessory    The accessory with which to open a session
 *  @param protocol     The unique protocol string used to create the session with the accessory
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory forProtocol:(NSString *)protocol;

/**
 *  Starts a session.
 */
- (void)startSession;

/// Stops the current session.
/// @param disconnectCompletionHandler Handler called when the session has been closed
- (void)destroySessionWithCompletionHandler:(void (^)(void))disconnectCompletionHandler;

/**
 *  Creates a session with the accessory.
 *
 *  @return Whether or not the session was created successfully
 */
- (BOOL)createSession;

/**
 *  Starts a session input or output stream.
 *
 *  @param stream The stream to be started.
 */
- (void)startStream:(NSStream *)stream;

/**
 *  Stops a session input or output stream.
 *
 *  @param stream The stream to be stopped.
 */
- (void)stopStream:(NSStream *)stream;

/**
 *  Cleans up a closed session
 */
- (void)cleanupClosedSession;


@end

NS_ASSUME_NONNULL_END
