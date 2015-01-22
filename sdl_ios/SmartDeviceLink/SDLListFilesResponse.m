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

- (void)setFilenames:(NSMutableArray *)filenames {
    [parameters setOrRemoveObject:filenames forKey:NAMES_filenames];
}

-(NSMutableArray*) filenames {
    return [parameters objectForKey:NAMES_filenames];
}

- (void)setSpaceAvailable:(NSNumber *)spaceAvailable {
    [parameters setOrRemoveObject:spaceAvailable forKey:NAMES_spaceAvailable];
}

-(NSNumber*) spaceAvailable {
    return [parameters objectForKey:NAMES_spaceAvailable];
}

@end
