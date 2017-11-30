//  SDLSystemRequest.h
//

#import "SDLRPCRequest.h"

#import "SDLRequestType.h"

/** An asynchronous request from the device; binary data can be included in hybrid part of message for some requests<br> (such as HTTP, Proprietary, or Authentication requests)
 * <p>
 * @since SmartDeviceLink 3.0
 *
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemRequest : SDLRPCRequest

- (instancetype)initWithType:(SDLRequestType)requestType fileName:(nullable NSString *)fileName;

@property (strong, nonatomic) SDLRequestType requestType;
@property (strong, nonatomic, nullable) NSString *fileName;

@end

NS_ASSUME_NONNULL_END
