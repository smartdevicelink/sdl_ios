//  SDLGenericResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Generic Response is sent, when the name of a received msg cannot be
 * retrieved. Only used in case of an error. Currently, only resultCode
 * INVALID_DATA is used.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGenericResponse : SDLRPCResponse

@end

NS_ASSUME_NONNULL_END
