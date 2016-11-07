//  SDLSetDisplayLayoutResponse.m
//


#import "SDLSetDisplayLayoutResponse.h"

#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLNames.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLSoftButtonCapabilities.h"

@implementation SDLSetDisplayLayoutResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetDisplayLayout]) {
    }
    return self;
}

- (void)setDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    [self setObject:displayCapabilities forName:SDLNameDisplayCapabilities];
}

- (SDLDisplayCapabilities *)displayCapabilities {
    NSObject *obj = [parameters objectForKey:SDLNameDisplayCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLDisplayCapabilities.class]) {
        return (SDLDisplayCapabilities *)obj;
    } else {
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setButtonCapabilities:(NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [self setObject:buttonCapabilities forName:SDLNameButtonCapabilities];
}

- (NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    NSMutableArray<SDLButtonCapabilities *> *array = [parameters objectForKey:SDLNameButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray<SDLButtonCapabilities *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLButtonCapabilities alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtonCapabilities:(NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    [self setObject:softButtonCapabilities forName:SDLNameSoftButtonCapabilities];
}

- (NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    NSMutableArray<SDLSoftButtonCapabilities *> *array = [parameters objectForKey:SDLNameSoftButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButtonCapabilities *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLSoftButtonCapabilities alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setPresetBankCapabilities:(SDLPresetBankCapabilities *)presetBankCapabilities {
    [self setObject:presetBankCapabilities forName:SDLNamePresetBankCapabilities];
}

- (SDLPresetBankCapabilities *)presetBankCapabilities {
    NSObject *obj = [parameters objectForKey:SDLNamePresetBankCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLPresetBankCapabilities.class]) {
        return (SDLPresetBankCapabilities *)obj;
    } else {
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
