//  SDLImageField.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLImageField.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLFileType.h>

@implementation SDLImageField

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setName:(SDLImageFieldName*) name {
    [store setOrRemoveObject:name forKey:NAMES_name];
}

-(SDLImageFieldName*) name {
    NSObject* obj = [store objectForKey:NAMES_name];
    if ([obj isKindOfClass:SDLImageFieldName.class]) {
        return (SDLImageFieldName*)obj;
    } else {
        return [SDLImageFieldName valueOf:(NSString*)obj];
    }
}

-(void) setImageTypeSupported:(NSMutableArray*) imageTypeSupported {
    [store setOrRemoveObject:imageTypeSupported forKey:NAMES_imageTypeSupported];
}

-(NSMutableArray*) imageTypeSupported {
    NSMutableArray* array = [store objectForKey:NAMES_imageTypeSupported];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLFileType.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLFileType valueOf:enumString]];
        }
        return newList;
    }
}

-(void) setImageResolution:(SDLImageResolution*) imageResolution {
    [store setOrRemoveObject:imageResolution forKey:NAMES_imageResolution];
}

-(SDLImageResolution*) imageResolution {
    NSObject* obj = [store objectForKey:NAMES_imageResolution];
    if ([obj isKindOfClass:SDLImageResolution.class]) {
        return (SDLImageResolution*)obj;
    } else {
        return [[SDLImageResolution alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
