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
@interface SDLIAPSession : NSObject <NSStreamDelegate>

/**
 *  Convenience initializer for setting an accessory and protocol string.
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
@property(readonly) BOOL bothStreamsOpen;

/**
 *  Closes the EASession inputStream and the outputStream.
 *  Sets bothStreamsOpen flag to false.
 *  Stops SDLIAPSesssion operation by removing streams from the run loop
 *  By design a SDLIAPSession instance cannot be reopened.
 */
- (void) closeSession;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  @returns True if the outputStream has space available to write data
 */
@property(readonly) BOOL hasSpaceAvailable;

/**
 *  @returns True if the sessions EAAccessory is connected
 */
@property(readonly) BOOL isConnected;

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
- (void)write:(NSMutableData *) data length: (NSUInteger) length  withCompletionHandler:(void (^)(NSInteger bytesWritten))completionHandler;

@end

NS_ASSUME_NONNULL_END

