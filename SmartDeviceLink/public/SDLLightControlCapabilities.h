//  SDLLightControlCapabilities.h
//

#import "SDLRPCMessage.h"
#import "SDLModuleInfo.h"

@class SDLLightCapabilities;

NS_ASSUME_NONNULL_BEGIN

/// Current light control capabilities.
///
/// @since RPC 5.0
@interface SDLLightControlCapabilities : SDLRPCStruct

/**
 Constructs a newly allocated SDLLightControlCapabilities object with given parameters
 
 
 @param moduleName friendly name of the light control module
 @param moduleInfo information about a RC module, including its id
 @param supportedLights array of available LightCapabilities
 @return An instance of the SDLLightControlCapabilities class
 */
- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo supportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights;

/**
 * @abstract  The short friendly name of the light control module.
 * It should not be used to identify a module by mobile application.
 *
 * Required, Max String length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract  An array of available LightCapabilities that are controllable.
 *
 * Required, NSArray of type SDLLightCapabilities minsize="1" maxsize="100"
 */
@property (strong, nonatomic) NSArray<SDLLightCapabilities *> *supportedLights;

/**
 *  Information about a RC module, including its id.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
