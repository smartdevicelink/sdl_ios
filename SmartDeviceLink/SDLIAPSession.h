//
//  SDLIAPSession.h
//

#import "SDLIAPSessionDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>

@class SDLStreamDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SessionCompletionHandler)(BOOL success);

@interface SDLIAPSession : NSObject

@property (nullable, strong, nonatomic) EAAccessory *accessory;
@property (nullable, strong, nonatomic) NSString *protocol;
@property (nullable, strong, nonatomic) EASession *easession;
@property (nullable, weak, nonatomic) id<SDLIAPSessionDelegate> delegate;
@property (nullable, strong, nonatomic) SDLStreamDelegate *streamDelegate;
@property (assign, readonly, getter=isStopped) BOOL stopped;

- (instancetype)initWithAccessory:(EAAccessory *)accessory
                      forProtocol:(NSString *)protocol;

- (BOOL)start;
- (void)stop;
- (void)sendData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
