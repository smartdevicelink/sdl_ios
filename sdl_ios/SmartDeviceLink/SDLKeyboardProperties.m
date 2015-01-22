//  SDLKeyboardProperties.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLKeyboardProperties.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLKeyboardProperties

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setLanguage:(SDLLanguage*) language {
    [store setOrRemoveObject:language forKey:NAMES_language];
}

-(SDLLanguage*) language {
    NSObject* obj = [store objectForKey:NAMES_language];
    if ([obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage*)obj;
    } else {
        return [SDLLanguage valueOf:(NSString*)obj];
    }
}

-(void) setKeyboardLayout:(SDLKeyboardLayout*) keyboardLayout {
    [store setOrRemoveObject:keyboardLayout forKey:NAMES_keyboardLayout];
}

-(SDLKeyboardLayout*) keyboardLayout {
    NSObject* obj = [store objectForKey:NAMES_keyboardLayout];
    if ([obj isKindOfClass:SDLKeyboardLayout.class]) {
        return (SDLKeyboardLayout*)obj;
    } else {
        return [SDLKeyboardLayout valueOf:(NSString*)obj];
    }
}

-(void) setKeypressMode:(SDLKeypressMode*) keypressMode {
    [store setOrRemoveObject:keypressMode forKey:NAMES_keypressMode];
}

-(SDLKeypressMode*) keypressMode {
    NSObject* obj = [store objectForKey:NAMES_keypressMode];
    if ([obj isKindOfClass:SDLKeypressMode.class]) {
        return (SDLKeypressMode*)obj;
    } else {
        return [SDLKeypressMode valueOf:(NSString*)obj];
    }
}

-(void) setLimitedCharacterList:(NSMutableArray*) limitedCharacterList {
    [store setOrRemoveObject:limitedCharacterList forKey:NAMES_limitedCharacterList];
}

-(NSMutableArray*) limitedCharacterList {
    return [store objectForKey:NAMES_limitedCharacterList];
}

-(void) setAutoCompleteText:(NSString*) autoCompleteText {
    [store setOrRemoveObject:autoCompleteText forKey:NAMES_autoCompleteText];
}

-(NSString*) autoCompleteText {
    return [store objectForKey:NAMES_autoCompleteText];
}

@end
