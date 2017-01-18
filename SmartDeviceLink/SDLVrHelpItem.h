//  SDLVRHelpItem.h
//

#import "SDLRPCMessage.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLVRHelpItem : SDLRPCStruct

- (instancetype)initWithText:(NSString *)text image:(nullable SDLImage *)image;

- (instancetype)initWithText:(NSString *)text image:(nullable SDLImage *)image position:(UInt8)position;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic, nullable) SDLImage *image;
@property (strong, nonatomic) NSNumber<SDLInt> *position;

@end

NS_ASSUME_NONNULL_END
