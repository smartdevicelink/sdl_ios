//  SDLGenericResponse.h
//


#import "SDLRPCResponse.h"

/**
 Generic Response is sent when the name of a received request is unknown. It is only used in case of an error. It will have an INVALID_DATA result code.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGenericResponse : SDLRPCResponse

@end

NS_ASSUME_NONNULL_END
