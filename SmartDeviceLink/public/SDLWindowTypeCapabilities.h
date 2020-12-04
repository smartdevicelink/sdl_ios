//
//  SDLWindowTypeCapabilities.h
//  SmartDeviceLink

#import "SDLRPCStruct.h"
#import "SDLWindowType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Used to inform an app how many window instances per type that can be created.
 
 @since SDL 6.0
 */
@interface SDLWindowTypeCapabilities : SDLRPCStruct

/**
 Init with required parameters

 @param type Type of windows available, to create.
 @param maximumNumberOfWindows Number of windows available, to create.
 */
- (instancetype)initWithType:(SDLWindowType)type maximumNumberOfWindows:(UInt32)maximumNumberOfWindows;

/**
 Type of windows available, to create.
 
 Required
 */
@property (strong, nonatomic) SDLWindowType type;

/**
 Number of windows available, to create.
 
 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *maximumNumberOfWindows;

@end

NS_ASSUME_NONNULL_END
