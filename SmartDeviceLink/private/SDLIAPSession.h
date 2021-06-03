//
//  SDLIAPSession.h
//

#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol SDLIAPSessionDelegate <NSObject>

- (void)streamsDidOpen;
- (void)streamsDidEnd;
- (void)streamHasSpaceToWrite;
- (void)streamDidError;
- (void)streamHasBytesAvailable:(NSInputStream *)inputStream;

@end
/**
 * Responsible for opening a connection with the accessory and transmitting data to and from the accessory. When the accessory disconnects, the connection is closed.
 * Once the connection with the accessory is closed, the connection can not be reopened; instead, a new `SDLIAPSession` must be created.
 */
@interface SDLIAPSession : NSObject <NSStreamDelegate>

/**
 *  Starts a session with the accessory.
 *
 *  @param accessory    The accessory with which to open a session
 *  @param protocol     The unique protocol string used to create the session with the accessory
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory forProtocol:(NSString *)protocol iAPSessionDelegate:(id<SDLIAPSessionDelegate>)iAPSessionDelegate;

/**
 *  The accessory that was used when creating a SLDLIAPSession instance.
 */
@property (nullable, strong, nonatomic, readonly) EAAccessory *accessory;

/**
 *  @returns True if both inputStream and outputStream are open
 */
@property(nonatomic, assign, readonly) BOOL bothStreamsOpen;

/**
 *  Closes the session's input and output streams. Once closed, the session can not be reopened.
 */
- (void)closeSession;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  @returns True if the outputStream has space available to write data
 */
@property(nonatomic, assign, readonly) BOOL hasSpaceAvailable;

/**
 *  @returns True if the sessions EAAccessory is connected
 */
@property(nonatomic, assign, readonly) BOOL isConnected;

/**
 *  @returns True if either the inputStream or the outputStream is open
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

/**
 *  The unique protocol string used to create the session with the accessory.
 */
@property (nullable, strong, nonatomic, readonly) NSString *protocolString;

/**
 *
 *  @param data  The data written to the EASession outputStream
 *  @param length The number of data bytes to write
 *  @param completionHandler  The number of data bytes actually written
 */
- (void)write:(NSMutableData *)data length:(NSUInteger)length withCompletionHandler:(void (^)(NSInteger bytesWritten))completionHandler;

@end

NS_ASSUME_NONNULL_END

