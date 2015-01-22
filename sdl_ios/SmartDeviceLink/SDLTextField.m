//  SDLTextField.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLTextField.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLTextField

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setName:(SDLTextFieldName*) name {
    [store setOrRemoveObject:name forKey:NAMES_name];
}

-(SDLTextFieldName*) name {
    NSObject* obj = [store objectForKey:NAMES_name];
    if ([obj isKindOfClass:SDLTextFieldName.class]) {
        return (SDLTextFieldName*)obj;
    } else {
        return [SDLTextFieldName valueOf:(NSString*)obj];
    }
}

-(void) setCharacterSet:(SDLCharacterSet*) characterSet {
    [store setOrRemoveObject:characterSet forKey:NAMES_characterSet];
}

-(SDLCharacterSet*) characterSet {
    NSObject* obj = [store objectForKey:NAMES_characterSet];
    if ([obj isKindOfClass:SDLCharacterSet.class]) {
        return (SDLCharacterSet*)obj;
    } else {
        return [SDLCharacterSet valueOf:(NSString*)obj];
    }
}

-(void) setWidth:(NSNumber*) width {
    [store setOrRemoveObject:width forKey:NAMES_width];
}

-(NSNumber*) width {
    return [store objectForKey:NAMES_width];
}

-(void) setRows:(NSNumber*) rows {
    [store setOrRemoveObject:rows forKey:NAMES_rows];
}

-(NSNumber*) rows {
    return [store objectForKey:NAMES_rows];
}

@end
