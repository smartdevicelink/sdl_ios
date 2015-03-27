//  SDLTextAlignment.m
//


#import "SDLTextAlignment.h"

SDLTextAlignment* SDLTextAlignment_LEFT_ALIGNED = nil;
SDLTextAlignment* SDLTextAlignment_RIGHT_ALIGNED = nil;
SDLTextAlignment* SDLTextAlignment_CENTERED = nil;

NSMutableArray* SDLTextAlignment_values = nil;

@implementation SDLTextAlignment

+(SDLTextAlignment*) valueOf:(NSString*) value {
    for (SDLTextAlignment* item in SDLTextAlignment.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLTextAlignment_values == nil) {
        SDLTextAlignment_values = [[NSMutableArray alloc] initWithObjects:
                SDLTextAlignment.LEFT_ALIGNED,
                SDLTextAlignment.RIGHT_ALIGNED,
                SDLTextAlignment.CENTERED,
                nil];
    }
    return SDLTextAlignment_values;
}

+(SDLTextAlignment*) LEFT_ALIGNED {
    if (SDLTextAlignment_LEFT_ALIGNED == nil) {
        SDLTextAlignment_LEFT_ALIGNED = [[SDLTextAlignment alloc] initWithValue:@"LEFT_ALIGNED"];
    }
    return SDLTextAlignment_LEFT_ALIGNED;
}

+(SDLTextAlignment*) RIGHT_ALIGNED {
    if (SDLTextAlignment_RIGHT_ALIGNED == nil) {
        SDLTextAlignment_RIGHT_ALIGNED = [[SDLTextAlignment alloc] initWithValue:@"RIGHT_ALIGNED"];
    }
    return SDLTextAlignment_RIGHT_ALIGNED;
}

+(SDLTextAlignment*) CENTERED {
    if (SDLTextAlignment_CENTERED == nil) {
        SDLTextAlignment_CENTERED = [[SDLTextAlignment alloc] initWithValue:@"CENTERED"];
    }
    return SDLTextAlignment_CENTERED;
}

@end
