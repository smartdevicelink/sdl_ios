//  SDLChoice.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLChoice.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLChoice

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setChoiceID:(NSNumber*) choiceID {
    [store setOrRemoveObject:choiceID forKey:NAMES_choiceID];
}

-(NSNumber*) choiceID {
    return [store objectForKey:NAMES_choiceID];
}

-(void) setMenuName:(NSString*) menuName {
    [store setOrRemoveObject:menuName forKey:NAMES_menuName];
}

-(NSString*) menuName {
    return [store objectForKey:NAMES_menuName];
}

-(void) setVrCommands:(NSMutableArray*) vrCommands {
    [store setOrRemoveObject:vrCommands forKey:NAMES_vrCommands];
}

-(NSMutableArray*) vrCommands {
    return [store objectForKey:NAMES_vrCommands];
}

-(void) setImage:(SDLImage*) image {
    [store setOrRemoveObject:image forKey:NAMES_image];
}

-(SDLImage*) image {
    NSObject* obj = [store objectForKey:NAMES_image];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setSecondaryText:(NSString*) secondaryText {
    [store setOrRemoveObject:secondaryText forKey:NAMES_secondaryText];
}

-(NSString*) secondaryText {
    return [store objectForKey:NAMES_secondaryText];
}

-(void) setTertiaryText:(NSString*) tertiaryText {
    [store setOrRemoveObject:tertiaryText forKey:NAMES_tertiaryText];
}

-(NSString*) tertiaryText {
    return [store objectForKey:NAMES_tertiaryText];
}

-(void) setSecondaryImage:(SDLImage*) secondaryImage {
    [store setOrRemoveObject:secondaryImage forKey:NAMES_secondaryImage];
}

-(SDLImage*) secondaryImage {
    NSObject* obj = [store objectForKey:NAMES_secondaryImage];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
