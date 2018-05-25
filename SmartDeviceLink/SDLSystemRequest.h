//  SDLSystemRequest.h
//

#import "SDLRPCRequest.h"

#import "SDLRequestType.h"

/*
 *  An asynchronous request from the device; binary data can be included in hybrid part of message for some requests (such as HTTP, Proprietary, or Authentication requests)
 *
 *  @since SmartDeviceLink 3.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemRequest : SDLRPCRequest

- (instancetype)initWithType:(SDLRequestType)requestType fileName:(nullable NSString *)fileName;

/**
 *  The type of system request. Note that Proprietary requests should forward the binary data to the known proprietary module on the system.
 *
 *  Required
 */
@property (strong, nonatomic) SDLRequestType requestType;

/**
 *  Filename of HTTP data to store in predefined system staging area.
 *
 *  Required if requestType is HTTP. PROPRIETARY requestType should ignore this parameter.
 */
@property (strong, nonatomic, nullable) NSString *fileName;

@end

NS_ASSUME_NONNULL_END
