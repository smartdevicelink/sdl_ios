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
    if (self = [super initWithName:NAMES_SetDisplayLayout]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    if (displayCapabilities != nil) {
        [parameters setObject:displayCapabilities forKey:NAMES_displayCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_displayCapabilities];
    }
}

- (SDLDisplayCapabilities *)displayCapabilities {
    NSObject *obj = [parameters objectForKey:NAMES_displayCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLDisplayCapabilities.class]) {
        return (SDLDisplayCapabilities *)obj;
    } else {
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setButtonCapabilities:(NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    if (buttonCapabilities != nil) {
        [parameters setObject:buttonCapabilities forKey:NAMES_buttonCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_buttonCapabilities];
    }
}

- (NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    NSMutableArray<SDLButtonCapabilities *> *array = [parameters objectForKey:NAMES_buttonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray<SDLButtonCapabilities *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtonCapabilities:(NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    if (softButtonCapabilities != nil) {
        [parameters setObject:softButtonCapabilities forKey:NAMES_softButtonCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_softButtonCapabilities];
    }
}

- (NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    NSMutableArray<SDLSoftButtonCapabilities *> *array = [parameters objectForKey:NAMES_softButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButtonCapabilities *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

- (void)setPresetBankCapabilities:(SDLPresetBankCapabilities *)presetBankCapabilities {
    if (presetBankCapabilities != nil) {
        [parameters setObject:presetBankCapabilities forKey:NAMES_presetBankCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_presetBankCapabilities];
    }
}

- (SDLPresetBankCapabilities *)presetBankCapabilities {
    NSObject *obj = [parameters objectForKey:NAMES_presetBankCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLPresetBankCapabilities.class]) {
        return (SDLPresetBankCapabilities *)obj;
    } else {
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
