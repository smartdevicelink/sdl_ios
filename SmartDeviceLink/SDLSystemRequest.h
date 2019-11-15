//  SDLSystemRequest.h
//

#import "SDLRPCRequest.h"

#import "SDLRequestType.h"

/**
 *  An asynchronous request from the device; binary data can be included in hybrid part of message for some requests (such as HTTP, Proprietary, or Authentication requests)
 *
 *  @since SmartDeviceLink 3.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemRequest : SDLRPCRequest

/**
 Create a generic system request with a file name

 @param requestType The request type to use
 @param fileName The name of the file to use
 @return The request
 */
- (instancetype)initWithType:(SDLRequestType)requestType fileName:(nullable NSString *)fileName;

/**
 Create an OEM_PROPRIETARY system request with a subtype and file name

 @param proprietaryType The proprietary requestSubType to be used
 @param fileName The name of the file to use
 @return The request
 */
- (instancetype)initWithProprietaryType:(NSString *)proprietaryType fileName:(nullable NSString *)fileName;

/**
 *  The type of system request. Note that Proprietary requests should forward the binary data to the known proprietary module on the system.
 *
 *  Required
 */
@property (strong, nonatomic) SDLRequestType requestType;

/**
 A request subType used when the `requestType` is `OEM_SPECIFIC`.

 Optional, Max length 255
 */
@property (strong, nonatomic, nullable) NSString *requestSubType;

/**
 *  Filename of HTTP data to store in predefined system staging area.
 *
 *  Required if requestType is HTTP. PROPRIETARY requestType should ignore this parameter.
 */
@property (strong, nonatomic, nullable) NSString *fileName;

@end

NS_ASSUME_NONNULL_END
