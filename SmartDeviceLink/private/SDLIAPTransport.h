//  SDLIAPTransport.h
//

#import <ExternalAccessory/ExternalAccessory.h>

#import "SDLTransportType.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPTransport : NSObject <SDLTransportType>

/**
 *  The subscribed listener.
 */
@property (nullable, weak, nonatomic) id<SDLTransportDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
