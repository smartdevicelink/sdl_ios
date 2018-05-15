//  SDLSRGBColor.m
//

#import "SDLSRGBColor.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLSRGBColor

- (instancetype)initWithRed:(UInt32)red green:(UInt32)green blue:(UInt32)blue {
    self = [self init];
    if(!self) {
        return nil;
    }
    
    self.red = @(red);
    self.green = @(green);
    self.blue = @(blue);

    return self;
}

- (void)setRed:(NSNumber<SDLInt> *)red {
    [store sdl_setObject:red forName:SDLNameRed];
}

- (NSNumber<SDLInt> *)red {
    return [store sdl_objectForName:SDLNameRed];
}

- (void)setGreen:(NSNumber<SDLInt> *)green {
    [store sdl_setObject:green forName:SDLNameGreen];
}

- (NSNumber<SDLInt> *)green {
    return [store sdl_objectForName:SDLNameGreen];
}

- (void)setBlue:(NSNumber<SDLInt> *)blue {
    [store sdl_setObject:blue forName:SDLNameBlue];
}

- (NSNumber<SDLInt> *)blue {
    return [store sdl_objectForName:SDLNameBlue];
}

@end

NS_ASSUME_NONNULL_END
