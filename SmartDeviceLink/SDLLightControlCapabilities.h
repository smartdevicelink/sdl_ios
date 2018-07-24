//  SDLLightControlCapabilities.h
//

#import "SDLRPCMessage.h"

@class SDLLightCapabilities;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLightControlCapabilities : SDLRPCStruct

- (instancetype)initWithModuleName:(NSString *)moduleName supportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights;

/**
 * @abstract    The short friendly name of the light control module.
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


@end

NS_ASSUME_NONNULL_END
