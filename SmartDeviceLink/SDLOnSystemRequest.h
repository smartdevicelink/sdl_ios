//  SDLOnSystemRequest.h
//

#import "SDLRPCNotification.h"

#import "SDLFileType.h"
#import "SDLRequestType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnSystemRequest : SDLRPCNotification

@property (strong, nonatomic) SDLRequestType requestType;
@property (nullable, strong, nonatomic) NSString *url;
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *timeout;
@property (nullable, strong, nonatomic) SDLFileType fileType;
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *offset;
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *length;

@end

NS_ASSUME_NONNULL_END
