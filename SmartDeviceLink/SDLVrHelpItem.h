//  SDLVRHelpItem.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


@interface SDLVRHelpItem : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithText:(NSString*)text image:(SDLImage*)image position:(NSNumber*)position;

@property (strong) NSString *text;
@property (strong) SDLImage *image;
@property (strong) NSNumber *position;

@end
