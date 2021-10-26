//
//  SDLNextFunctionInfo.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

#import "SDLNextFunction.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Outlines information about the next RPC that will be triggered.
 */

@interface SDLNextFunctionInfo : SDLRPCStruct

- (instancetype)initWithNextFunction:(SDLNextFunction)nextFunction loadingText:(NSString *)loadingText;

/**
 * The next function (RPC) that will be triggered by selecting the current option/command/choice etc. In the format of interfaceName.RPCMessage.
 */
@property (assign, nonatomic) SDLNextFunction nextFunction;

/**
 * This lets the HMI know what text to show while waiting for the next RPC.
 *
 * Optional
 */
@property (nullable, copy, nonatomic) NSString *loadingText;

@end

NS_ASSUME_NONNULL_END
