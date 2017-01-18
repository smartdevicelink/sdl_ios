//  SDLVRHelpItem.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


@interface SDLVRHelpItem : SDLRPCStruct

- (instancetype)initWithText:(NSString *)text image:(SDLImage *)image;

- (instancetype)initWithText:(NSString *)text image:(SDLImage *)image position:(UInt8)position;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) SDLImage *image;
@property (strong, nonatomic) NSNumber<SDLInt> *position;

@end
