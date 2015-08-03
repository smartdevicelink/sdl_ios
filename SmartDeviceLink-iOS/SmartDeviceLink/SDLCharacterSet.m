//  SDLCharacterSet.m
//


#import "SDLCharacterSet.h"

SDLCharacterSet *SDLCharacterSet_TYPE2SET = nil;
SDLCharacterSet *SDLCharacterSet_TYPE5SET = nil;
SDLCharacterSet *SDLCharacterSet_CID1SET = nil;
SDLCharacterSet *SDLCharacterSet_CID2SET = nil;

NSArray *SDLCharacterSet_values = nil;

@implementation SDLCharacterSet

+ (SDLCharacterSet *)valueOf:(NSString *)value {
    for (SDLCharacterSet *item in SDLCharacterSet.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLCharacterSet_values == nil) {
        SDLCharacterSet_values = @[
            SDLCharacterSet.TYPE2SET,
            SDLCharacterSet.TYPE5SET,
            SDLCharacterSet.CID1SET,
            SDLCharacterSet.CID2SET,
        ];
    }
    return SDLCharacterSet_values;
}

+ (SDLCharacterSet *)TYPE2SET {
    if (SDLCharacterSet_TYPE2SET == nil) {
        SDLCharacterSet_TYPE2SET = [[SDLCharacterSet alloc] initWithValue:@"TYPE2SET"];
    }
    return SDLCharacterSet_TYPE2SET;
}

+ (SDLCharacterSet *)TYPE5SET {
    if (SDLCharacterSet_TYPE5SET == nil) {
        SDLCharacterSet_TYPE5SET = [[SDLCharacterSet alloc] initWithValue:@"TYPE5SET"];
    }
    return SDLCharacterSet_TYPE5SET;
}

+ (SDLCharacterSet *)CID1SET {
    if (SDLCharacterSet_CID1SET == nil) {
        SDLCharacterSet_CID1SET = [[SDLCharacterSet alloc] initWithValue:@"CID1SET"];
    }
    return SDLCharacterSet_CID1SET;
}

+ (SDLCharacterSet *)CID2SET {
    if (SDLCharacterSet_CID2SET == nil) {
        SDLCharacterSet_CID2SET = [[SDLCharacterSet alloc] initWithValue:@"CID2SET"];
    }
    return SDLCharacterSet_CID2SET;
}

@end
