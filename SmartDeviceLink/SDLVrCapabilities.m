//  SDLVRCapabilities.m
//


#import "SDLVrCapabilities.h"

SDLVRCapabilities *SDLVRCapabilities_TEXT = nil;

NSArray *SDLVRCapabilities_values = nil;

@implementation SDLVRCapabilities

+ (SDLVRCapabilities *)valueOf:(NSString *)value {
    for (SDLVRCapabilities *item in SDLVRCapabilities.values) {
        //NOTE: This was added for Sync Module Compatability, V1 module resturns "Text" and a
        //      Gen 1.1 module returns "TEXT", the new if statement makes a case insensitive
        //      check instead to accept both
        //if ([item.value isEqualToString:value]) {
        if (item.value && [item.value caseInsensitiveCompare:value] == NSOrderedSame) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLVRCapabilities_values == nil) {
        SDLVRCapabilities_values = @[
            SDLVRCapabilities.TEXT,
        ];
    }
    return SDLVRCapabilities_values;
}

+ (SDLVRCapabilities *)TEXT {
    if (SDLVRCapabilities_TEXT == nil) {
        SDLVRCapabilities_TEXT = [[SDLVRCapabilities alloc] initWithValue:@"TEXT"];
    }
    return SDLVRCapabilities_TEXT;
}

@end
