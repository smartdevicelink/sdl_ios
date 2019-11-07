//  SDLFunctionID.h
//

#import <Foundation/Foundation.h>
#import "NSNumber+NumberType.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

/// A function ID for an SDL RPC
@interface SDLFunctionID : NSObject

/// The shared object for pulling function id information
+ (instancetype)sharedInstance;

/// Gets the function name for a given function ID
///
/// @param functionID A function ID
/// @returns An SDLRPCFunctionName
- (nullable SDLRPCFunctionName)functionNameForId:(UInt32)functionID;


/// Gets the function ID from a function name
///
/// @param functionName The RPC function name
- (nullable NSNumber<SDLInt> *)functionIdForName:(SDLRPCFunctionName)functionName;

@end

NS_ASSUME_NONNULL_END
