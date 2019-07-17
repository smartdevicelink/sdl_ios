//
//  SDLTemplateConfiguration.h
//  SmartDeviceLink

#import "SDLTemplateColorScheme.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @since 6.0
 */
@interface SDLTemplateConfiguration : SDLRPCStruct

/**
 * @param templateName Predefined or dynamically created window template.
 *                     Currently only predefined window template layouts are defined.
 */
- (instancetype)initWithTemplate:(NSString *)templateName NS_DESIGNATED_INITIALIZER;


/**
 * @param templateName Predefined or dynamically created window template.
 *                     Currently only predefined window template layouts are defined.
 *
 * @param dayColorScheme The color scheme to use when the head unit is in a light / day situation.
 *
 * @param nightColorScheme The color scheme to use when the head unit is in a dark / night situation.
 */
- (instancetype)initWithTemplate:(NSString *)templateName dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/**
 * Predefined or dynamically created window template.
 * Currently only predefined window template layouts are defined.
 */
@property (strong, nonatomic) NSString *templateName;

/**
 * dayColorScheme The color scheme to use when the head unit is in a light / day situation.
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *dayColorScheme;

/**
 * The color scheme to use when the head unit is in a dark / night situation.
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *nightColorScheme;

@end

NS_ASSUME_NONNULL_END
