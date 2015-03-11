//  SDLVrCapabilities.m
//


#import "SDLVrCapabilities.h"

SDLVrCapabilities* SDLVrCapabilities_TEXT = nil;

NSArray* SDLVrCapabilities_values = nil;

@implementation SDLVrCapabilities

+(SDLVrCapabilities*) valueOf:(NSString*) value {
    for (SDLVrCapabilities* item in SDLVrCapabilities.values) {
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

+(NSArray*) values {
    if (SDLVrCapabilities_values == nil) {
        SDLVrCapabilities_values = @[
                SDLVrCapabilities.TEXT,
                ];
    }
    return SDLVrCapabilities_values;
}

+(SDLVrCapabilities*) TEXT {
    if (SDLVrCapabilities_TEXT == nil) {
        SDLVrCapabilities_TEXT = [[SDLVrCapabilities alloc] initWithValue:@"TEXT"];
    }
    return SDLVrCapabilities_TEXT;
}

@end
