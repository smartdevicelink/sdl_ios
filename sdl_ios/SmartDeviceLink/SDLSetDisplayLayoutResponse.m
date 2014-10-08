//  SDLSetDisplayLayoutResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSetDisplayLayoutResponse.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLButtonCapabilities.h>
#import <SmartDeviceLink/SDLSoftButtonCapabilities.h>

@implementation SDLSetDisplayLayoutResponse

-(id) init {
    if (self = [super initWithName:NAMES_SetDisplayLayout]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setDisplayCapabilities:(SDLDisplayCapabilities*) displayCapabilities {
    if (displayCapabilities != nil) {
        [parameters setObject:displayCapabilities forKey:NAMES_displayCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_displayCapabilities];
    }
}

-(SDLDisplayCapabilities*) displayCapabilities {
    NSObject* obj = [parameters objectForKey:NAMES_displayCapabilities];
    if ([obj isKindOfClass:SDLDisplayCapabilities.class]) {
        return (SDLDisplayCapabilities*)obj;
    } else {
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setButtonCapabilities:(NSMutableArray*) buttonCapabilities {
    if (buttonCapabilities != nil) {
        [parameters setObject:buttonCapabilities forKey:NAMES_buttonCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_buttonCapabilities];
    }
}

-(NSMutableArray*) buttonCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_buttonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

-(void) setSoftButtonCapabilities:(NSMutableArray*) softButtonCapabilities {
    if (softButtonCapabilities != nil) {
        [parameters setObject:softButtonCapabilities forKey:NAMES_softButtonCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_softButtonCapabilities];
    }
}

-(NSMutableArray*) softButtonCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_softButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLSoftButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

-(void) setPresetBankCapabilities:(SDLPresetBankCapabilities*) presetBankCapabilities {
    if (presetBankCapabilities != nil) {
        [parameters setObject:presetBankCapabilities forKey:NAMES_presetBankCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_presetBankCapabilities];
    }
}

-(SDLPresetBankCapabilities*) presetBankCapabilities {
    NSObject* obj = [parameters objectForKey:NAMES_presetBankCapabilities];
    if ([obj isKindOfClass:SDLPresetBankCapabilities.class]) {
        return (SDLPresetBankCapabilities*)obj;
    } else {
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
