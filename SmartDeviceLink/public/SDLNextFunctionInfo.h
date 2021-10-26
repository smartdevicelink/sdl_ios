//
//  SDLNextFunctionInfo.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

#import "SDLNextFunction.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Outlines information about the next RPC that will be triggered.
 */

@interface SDLNextFunctionInfo : NSObject <NSCopying>

- (instancetype)initWithNextFunction:(SDLNextFunction)nextFunction loadingText:(NSString *)loadingText;

@property (assign, nonatomic) SDLNextFunction nextFunction;

@property (nonatomic, readonly) UInt32 nextFunctionID;

@property (copy, nonatomic) NSString *loadingText;

@end

NS_ASSUME_NONNULL_END
