//
//  SDLWindowTypeCapabilities.h
//  SmartDeviceLink

#import "SDLRPCStruct.h"
#import "SDLWindowType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Used to inform an app how many window instances per type that can be created.
 *
 * @since SDL 6.0
 */
@interface SDLWindowTypeCapabilities : SDLRPCStruct

/**
 * @param type Type of windows available, to create.
 *
 * @param maximumNumberOfWindows Number of windows available, to create.
 */
- (instancetype)initWithType:(SDLWindowType)type maximumNumberOfWindows:(UInt32)maximumNumberOfWindows NS_DESIGNATED_INITIALIZER;

/**
 * Type of windows available, to create.
 */
@property (strong, nonatomic) SDLWindowType type;

/**
 * Nuber of windows available, to create.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *maximumNumberOfWindows;

@end

NS_ASSUME_NONNULL_END
