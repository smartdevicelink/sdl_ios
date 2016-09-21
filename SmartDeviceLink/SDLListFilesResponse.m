//  SDLListFilesResponse.m
//


#import "SDLListFilesResponse.h"



@implementation SDLListFilesResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameListFiles]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setFilenames:(NSMutableArray *)filenames {
    if (filenames != nil) {
        [parameters setObject:filenames forKey:SDLNameFilenames];
    } else {
        [parameters removeObjectForKey:SDLNameFilenames];
    }
}

- (NSMutableArray *)filenames {
    return [parameters objectForKey:SDLNameFilenames];
}

- (void)setSpaceAvailable:(NSNumber *)spaceAvailable {
    if (spaceAvailable != nil) {
        [parameters setObject:spaceAvailable forKey:SDLNameSpaceAvailable];
    } else {
        [parameters removeObjectForKey:SDLNameSpaceAvailable];
    }
}

- (NSNumber *)spaceAvailable {
    return [parameters objectForKey:SDLNameSpaceAvailable];
}

@end
