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

- (instancetype)initWithType:(SDLRequestType *)requestType fileName:(NSString *)fileName;

@property (strong) SDLRequestType *requestType;
@property (strong) NSString *fileName;

@end
