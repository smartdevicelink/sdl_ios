//  SDLSetDisplayLayout.h
//


#import "SDLRPCRequest.h"

#import "SDLPredefinedLayout.h"

@class SDLTemplateColorScheme;

NS_ASSUME_NONNULL_BEGIN

/**
 * Used to set an alternate display layout. If not sent, default screen for
 * given platform will be shown
 *
 * Since SmartDeviceLink 2.0
 */
__deprecated_msg("Use SDLManager.screenManager.changeLayout() instead")
@interface SDLSetDisplayLayout : SDLRPCRequest

/// Convenience init to set a display layout
///
/// @param predefinedLayout A template layout an app uses to display information
/// @return An SDLSetDisplayLayout object
- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout;

/// Convenience init to set a display layout
///
/// @param displayLayout A display layout name
/// @return An SDLSetDisplayLayout object
- (instancetype)initWithLayout:(NSString *)displayLayout;

/// Convenience init to set a display layout
///
/// @param predefinedLayout A display layout. Predefined or dynamically created screen layout
/// @param dayColorScheme The color scheme to be used on a head unit using a "light" or "day" color scheme
/// @param nightColorScheme The color scheme to be used on a head unit using a "dark" or "night" color scheme
/// @return An SDLSetDisplayLayout object
- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout dayColorScheme:(SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(SDLTemplateColorScheme *)nightColorScheme;

/// Convenience init to set a display layout
/// @param displayLayout A display layout name
/// @param dayColorScheme The color scheme to be used on a head unit using a "light" or "day" color scheme
/// @param nightColorScheme The color scheme to be used on a head unit using a "dark" or "night" color scheme
/// @return An SDLSetDisplayLayout object
- (instancetype)initWithLayout:(NSString *)displayLayout dayColorScheme:(SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(SDLTemplateColorScheme *)nightColorScheme;

/**
 * A display layout. Predefined or dynamically created screen layout.
 * Currently only predefined screen layouts are defined. Predefined layouts
 * include: "ONSCREEN_PRESETS" Custom screen containing app-defined onscreen
 * presets. Currently defined for GEN2
 */
@property (strong, nonatomic) NSString *displayLayout;

/**
 The color scheme to be used on a head unit using a "light" or "day" color scheme. The OEM may only support this theme if their head unit only has a light color scheme.

 Optional
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *dayColorScheme;

/**
 The color scheme to be used on a head unit using a "dark" or "night" color scheme. The OEM may only support this theme if their head unit only has a dark color scheme.

 Optional
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *nightColorScheme;

@end

NS_ASSUME_NONNULL_END
