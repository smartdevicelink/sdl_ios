//
//  SDLTemplateConfiguration.h
//  SmartDeviceLink

#import "SDLTemplateColorScheme.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Used to set an alternate template layout to a window.
 * @since SDL 6.0
 */
@interface SDLTemplateConfiguration : SDLRPCStruct

/**
 * @param template Predefined or dynamically created window template.
 *                     Currently only predefined window template layouts are defined.
 */
- (instancetype)initWithTemplate:(NSString *)template NS_DESIGNATED_INITIALIZER;


/**
 * @param template         Predefined or dynamically created window template.
 *                         Currently only predefined window template layouts are defined.
 *
 * @param dayColorScheme   The color scheme to use when the head unit is in a light / day situation.
 *
 * @param nightColorScheme The color scheme to use when the head unit is in a dark / night situation.
 */
- (instancetype)initWithTemplate:(NSString *)template dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/**
 * Predefined or dynamically created window template.
 * Currently only predefined window template layouts are defined.
 */
@property (strong, nonatomic) NSString *template;

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
