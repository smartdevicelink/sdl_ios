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

@property (nullable, strong, atomic) EAAccessory *accessory;
@property (nullable, strong, atomic) NSString *protocol;
@property (nullable, strong, atomic) EASession *easession;
@property (nullable, weak) id<SDLIAPSessionDelegate> delegate;
@property (nullable, strong, atomic) SDLStreamDelegate *streamDelegate;

- (instancetype)initWithAccessory:(EAAccessory *)accessory
                      forProtocol:(NSString *)protocol;

- (BOOL)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
