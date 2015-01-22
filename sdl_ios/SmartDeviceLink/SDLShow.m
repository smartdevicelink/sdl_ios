//  SDLShow.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLShow.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLSoftButton.h>

@implementation SDLShow

-(id) init {
    if (self = [super initWithName:NAMES_Show]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setMainField1:(NSString *)mainField1 {
    [parameters setOrRemoveObject:mainField1 forKey:NAMES_mainField1];
}

-(NSString*) mainField1 {
    return [parameters objectForKey:NAMES_mainField1];
}

- (void)setMainField2:(NSString *)mainField2 {
    [parameters setOrRemoveObject:mainField2 forKey:NAMES_mainField2];
}

-(NSString*) mainField2 {
    return [parameters objectForKey:NAMES_mainField2];
}

- (void)setMainField3:(NSString *)mainField3 {
    [parameters setOrRemoveObject:mainField3 forKey:NAMES_mainField3];
}

-(NSString*) mainField3 {
    return [parameters objectForKey:NAMES_mainField3];
}

- (void)setMainField4:(NSString *)mainField4 {
    [parameters setOrRemoveObject:mainField4 forKey:NAMES_mainField4];
}

-(NSString*) mainField4 {
    return [parameters objectForKey:NAMES_mainField4];
}

- (void)setAlignment:(SDLTextAlignment *)alignment {
    [parameters setOrRemoveObject:alignment forKey:NAMES_alignment];
}

-(SDLTextAlignment*) alignment {
    NSObject* obj = [parameters objectForKey:NAMES_alignment];
    if ([obj isKindOfClass:SDLTextAlignment.class]) {
        return (SDLTextAlignment*)obj;
    } else {
        return [SDLTextAlignment valueOf:(NSString*)obj];
    }
}

- (void)setStatusBar:(NSString *)statusBar {
    [parameters setOrRemoveObject:statusBar forKey:NAMES_statusBar];
}

-(NSString*) statusBar {
    return [parameters objectForKey:NAMES_statusBar];
}

- (void)setMediaClock:(NSString *)mediaClock {
    [parameters setOrRemoveObject:mediaClock forKey:NAMES_mediaClock];
}

-(NSString*) mediaClock {
    return [parameters objectForKey:NAMES_mediaClock];
}

- (void)setMediaTrack:(NSString *)mediaTrack {
    [parameters setOrRemoveObject:mediaTrack forKey:NAMES_mediaTrack];
}

-(NSString*) mediaTrack {
    return [parameters objectForKey:NAMES_mediaTrack];
}

- (void)setGraphic:(SDLImage *)graphic {
    [parameters setOrRemoveObject:graphic forKey:NAMES_graphic];
}

-(SDLImage*) graphic {
    NSObject* obj = [parameters objectForKey:NAMES_graphic];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setSecondaryGraphic:(SDLImage *)secondaryGraphic {
    [parameters setOrRemoveObject:secondaryGraphic forKey:NAMES_secondaryGraphic];
}

-(SDLImage*) secondaryGraphic {
    NSObject* obj = [parameters objectForKey:NAMES_secondaryGraphic];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    [parameters setOrRemoveObject:softButtons forKey:NAMES_softButtons];
}

-(NSMutableArray*) softButtons {
    NSMutableArray* array = [parameters objectForKey:NAMES_softButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setCustomPresets:(NSMutableArray *)customPresets {
    [parameters setOrRemoveObject:customPresets forKey:NAMES_customPresets];
}

-(NSMutableArray*) customPresets {
    return [parameters objectForKey:NAMES_customPresets];
}

@end
