//
//  SDLIAPSession.h
//

#import "SDLIAPSessionDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>

@class SDLStreamDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^SessionSendHandler)(NSError **error);

@interface SDLIAPSession : NSObject

@property (nullable, strong, nonatomic) EAAccessory *accessory;
@property (nullable, strong, nonatomic) NSString *protocol;
@property (nullable, strong, nonatomic) EASession *easession;
@property (nullable, weak, nonatomic) id<SDLIAPSessionDelegate> delegate;
@property (nullable, strong, nonatomic) SDLStreamDelegate *streamDelegate;

- (instancetype)initWithAccessory:(EAAccessory *)accessory
                      forProtocol:(NSString *)protocol;

- (BOOL)start;
- (void)stop;
- (void)sendData:(SessionSendHandler)sender;

@end

NS_ASSUME_NONNULL_END
