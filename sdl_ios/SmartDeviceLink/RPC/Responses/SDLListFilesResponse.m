//  SDLListFilesResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLListFilesResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLListFilesResponse

-(id) init {
    if (self = [super initWithName:NAMES_ListFiles]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setFilenames:(NSMutableArray*) filenames {
    if (filenames != nil) {
        [parameters setObject:filenames forKey:NAMES_filenames];
    } else {
        [parameters removeObjectForKey:NAMES_filenames];
    }
}

-(NSMutableArray*) filenames {
    return [parameters objectForKey:NAMES_filenames];
}

-(void) setSpaceAvailable:(NSNumber*) spaceAvailable {
    if (spaceAvailable != nil) {
        [parameters setObject:spaceAvailable forKey:NAMES_spaceAvailable];
    } else {
        [parameters removeObjectForKey:NAMES_spaceAvailable];
    }
}

-(NSNumber*) spaceAvailable {
    return [parameters objectForKey:NAMES_spaceAvailable];
}

@end
