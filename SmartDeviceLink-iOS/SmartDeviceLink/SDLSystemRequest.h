//  SDLSystemRequest.h
//

#import "SDLRPCRequest.h"

@class SDLRequestType;


/** An asynchronous request from the device; binary data can be included in hybrid part of message for some requests<br> (such as HTTP, Proprietary, or Authentication requests)
 * <p>
 * @since SmartDeviceLink 3.0
 *
 */
@interface SDLSystemRequest : SDLRPCRequest {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * The type of system request.
 * Note that Proprietary requests should forward the binary data to the known proprietary module on the system.
 */
@property (strong) SDLRequestType *requestType;

/**
 * Filename of HTTP data to store in predefined system staging area.
 * Mandatory if requestType is HTTP.
 * PROPRIETARY requestType should ignore this parameter.
 */
@property (strong) NSString *fileName;

@end
