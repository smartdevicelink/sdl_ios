//  SDLOnSystemRequest.h
//

#import "SDLRPCNotification.h"

#import "SDLFileType.h"
#import "SDLRequestType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An asynchronous request from the system for specific data from the device or the cloud or response to a request from the device or cloud Binary data can be included in hybrid part of message for some requests (such as Authentication request responses)
 */
@interface SDLOnSystemRequest : SDLRPCNotification

/**
 The type of system request.
 */
@property (strong, nonatomic) SDLRequestType requestType;

/**
 A request subType used when the `requestType` is `OEM_SPECIFIC`.

 Optional, Max length 255
 */
@property (strong, nonatomic, nullable) NSString *requestSubType;

/**
 Optional URL for HTTP requests. If blank, the binary data shall be forwarded to the app. If not blank, the binary data shall be forwarded to the url with a provided timeout in seconds.
 */
@property (nullable, strong, nonatomic) NSString *url;

/**
 Optional timeout for HTTP requests Required if a URL is provided
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *timeout;

/**
 Optional file type (meant for HTTP file requests).
 */
@property (nullable, strong, nonatomic) SDLFileType fileType;

/**
 Optional offset in bytes for resuming partial data chunks
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *offset;

/**
 Optional length in bytes for resuming partial data chunks
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *length;

@end

NS_ASSUME_NONNULL_END
