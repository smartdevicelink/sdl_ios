//  SDLDimension.m
//


#import "SDLDimension.h"

SDLDimension *SDLDimension_NO_FIX = nil;
SDLDimension *SDLDimension_2D = nil;
SDLDimension *SDLDimension_3D = nil;

NSArray *SDLDimension_values = nil;

@implementation SDLDimension

+ (SDLDimension *)valueOf:(NSString *)value {
    for (SDLDimension *item in SDLDimension.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLDimension_values == nil) {
        SDLDimension_values = @[
            SDLDimension.NO_FIX,
            SDLDimension._2D,
            SDLDimension._3D,
        ];
    }
    return SDLDimension_values;
}

+ (SDLDimension *)NO_FIX {
    if (SDLDimension_NO_FIX == nil) {
        SDLDimension_NO_FIX = [[SDLDimension alloc] initWithValue:@"NO_FIX"];
    }
    return SDLDimension_NO_FIX;
}

+ (SDLDimension *)_2D {
    if (SDLDimension_2D == nil) {
        SDLDimension_2D = [[SDLDimension alloc] initWithValue:@"2D"];
    }
    return SDLDimension_2D;
}

+ (SDLDimension *)_3D {
    if (SDLDimension_3D == nil) {
        SDLDimension_3D = [[SDLDimension alloc] initWithValue:@"3D"];
    }
    return SDLDimension_3D;
}

@end
