//  SDLSetDisplayLayout.h
//


#import "SDLRPCRequest.h"

@class SDLPredefinedLayout;

/**
 * Used to set an alternate display layout. If not sent, default screen for
 * given platform will be shown
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLSetDisplayLayout : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLSetDisplayLayout object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLSetDisplayLayout object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout *)predefinedLayout;

- (instancetype)initWithLayout:(NSString *)displayLayout;


/**
 * @abstract A display layout. Predefined or dynamically created screen layout.
 * Currently only predefined screen layouts are defined. Predefined layouts
 * include: "ONSCREEN_PRESETS" Custom screen containing app-defined onscreen
 * presets. Currently defined for GEN2
 */
@property (strong) NSString *displayLayout;

@end
