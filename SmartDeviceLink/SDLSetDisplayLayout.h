//  SDLSetDisplayLayout.h
//


#import "SDLRPCRequest.h"

#import "SDLPredefinedLayout.h"

/**
 * Used to set an alternate display layout. If not sent, default screen for
 * given platform will be shown
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSetDisplayLayout : SDLRPCRequest

- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout;

- (instancetype)initWithLayout:(NSString *)displayLayout;


/**
 * A display layout. Predefined or dynamically created screen layout.
 * Currently only predefined screen layouts are defined. Predefined layouts
 * include: "ONSCREEN_PRESETS" Custom screen containing app-defined onscreen
 * presets. Currently defined for GEN2
 */
@property (strong, nonatomic) NSString *displayLayout;

@end

NS_ASSUME_NONNULL_END
