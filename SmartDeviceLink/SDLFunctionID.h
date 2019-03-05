//  SDLFunctionID.h
//

#import <Foundation/Foundation.h>
#import "NSNumber+NumberType.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFunctionID : NSObject

+ (instancetype)sharedInstance;

- (nullable SDLRPCFunctionName)functionNameForId:(UInt32)functionID;
- (nullable NSNumber<SDLInt> *)functionIdForName:(SDLRPCFunctionName)functionName;

@end

NS_ASSUME_NONNULL_END
