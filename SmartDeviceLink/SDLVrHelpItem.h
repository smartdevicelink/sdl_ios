//  SDLVRHelpItem.h
//

#import "SDLRPCMessage.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN

/**
 A help item for voice commands, used locally in interaction lists and globally
 */
@interface SDLVRHelpItem : SDLRPCStruct

- (instancetype)initWithText:(NSString *)text image:(nullable SDLImage *)image;

- (instancetype)initWithText:(NSString *)text image:(nullable SDLImage *)image position:(UInt8)position;

/**
 Text to display for VR Help item

 Required
 */
@property (strong, nonatomic) NSString *text;

/**
 Image for VR Help item

 Optional
 */
@property (strong, nonatomic, nullable) SDLImage *image;

/**
 Position to display item in VR Help list

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *position;

@end

NS_ASSUME_NONNULL_END
