//
//  SDLTemplateConfiguration.h
//  SmartDeviceLink

#import "SDLTemplateColorScheme.h"
#import "SDLPredefinedLayout.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Used to set an alternate template layout to a window.

 @since SDL 6.0
 */
@interface SDLTemplateConfiguration : SDLRPCStruct


/**
 Constructor with the required values.

 @param predefinedLayout A template layout an app uses to display information. The broad details of the layout are defined, but the details depend on the IVI system. Used in SetDisplayLayout.
 */
- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout;

// HAX: We are doing this because `template` is a C++ keyword and won't compile.
#ifndef __cplusplus
/**
 Init with the required values.

 @param template Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 */
- (instancetype)initWithTemplate:(NSString *)template;


/**
 Convinience constructor with all the parameters.

 @param template Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 @param dayColorScheme The color scheme to use when the head unit is in a light / day situation. If nil, the existing color scheme will be used.
 @param nightColorScheme The color scheme to use when the head unit is in a dark / night situation.
 */
- (instancetype)initWithTemplate:(NSString *)template dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/**
 Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 */
@property (strong, nonatomic) NSString *template;
#endif

#ifdef __cplusplus
/**
 Init with the required values.

 @param templateName Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 */
- (instancetype)initWithTemplate:(NSString *)templateName;


/**
 Convinience constructor with all the parameters.

 @param templateName Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 @param dayColorScheme The color scheme to use when the head unit is in a light / day situation. If nil, the existing color scheme will be used.
 @param nightColorScheme The color scheme to use when the head unit is in a dark / night situation.
 */
- (instancetype)initWithTemplate:(NSString *)templateName dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/**
 Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 */
@property (strong, nonatomic) NSString *templateName;
#endif

/**
 The color scheme to use when the head unit is in a light / day situation.
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *dayColorScheme;

/**
 The color scheme to use when the head unit is in a dark / night situation.
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *nightColorScheme;

@end

NS_ASSUME_NONNULL_END
