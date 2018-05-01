//  SDLIAPTransport.h
//

#import <ExternalAccessory/ExternalAccessory.h>

#import "SDLTransportType.h"
#import "SDLIAPSessionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPTransport : NSObject <SDLTransportType, SDLIAPSessionDelegate>

@property (nullable, strong, nonatomic) SDLIAPSession *controlSession;
@property (nullable, strong, nonatomic) SDLIAPSession *session;

@property (nullable, weak, nonatomic) id<SDLTransportDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
