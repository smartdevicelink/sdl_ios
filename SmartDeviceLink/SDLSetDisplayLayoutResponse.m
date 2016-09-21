//  SDLSetDisplayLayoutResponse.m
//


#import "SDLSetDisplayLayoutResponse.h"

#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"

#import "SDLPresetBankCapabilities.h"
#import "SDLSoftButtonCapabilities.h"


@implementation SDLSetDisplayLayoutResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetDisplayLayout]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    if (displayCapabilities != nil) {
        [parameters setObject:displayCapabilities forKey:SDLNameDisplayCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameDisplayCapabilities];
    }
}

- (SDLDisplayCapabilities *)displayCapabilities {
    NSObject *obj = [parameters objectForKey:SDLNameDisplayCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLDisplayCapabilities.class]) {
        return (SDLDisplayCapabilities *)obj;
    } else {
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setButtonCapabilities:(NSMutableArray *)buttonCapabilities {
    if (buttonCapabilities != nil) {
        [parameters setObject:buttonCapabilities forKey:SDLNameButtonCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameButtonCapabilities];
    }
}

- (NSMutableArray *)buttonCapabilities {
    NSMutableArray *array = [parameters objectForKey:SDLNameButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtonCapabilities:(NSMutableArray *)softButtonCapabilities {
    if (softButtonCapabilities != nil) {
        [parameters setObject:softButtonCapabilities forKey:SDLNameSoftButtonCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtonCapabilities];
    }
}

- (NSMutableArray *)softButtonCapabilities {
    NSMutableArray *array = [parameters objectForKey:SDLNameSoftButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setPresetBankCapabilities:(SDLPresetBankCapabilities *)presetBankCapabilities {
    if (presetBankCapabilities != nil) {
        [parameters setObject:presetBankCapabilities forKey:SDLNamePresetBankCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNamePresetBankCapabilities];
    }
}

- (SDLPresetBankCapabilities *)presetBankCapabilities {
    NSObject *obj = [parameters objectForKey:SDLNamePresetBankCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLPresetBankCapabilities.class]) {
        return (SDLPresetBankCapabilities *)obj;
    } else {
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
