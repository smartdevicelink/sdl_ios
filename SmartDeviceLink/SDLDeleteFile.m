//  SDLDeleteFile.m
//


#import "SDLDeleteFile.h"



@implementation SDLDeleteFile

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteFile]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setSyncFileName:(NSString *)syncFileName {
    if (syncFileName != nil) {
        [parameters setObject:syncFileName forKey:SDLNameSyncFileName];
    } else {
        [parameters removeObjectForKey:SDLNameSyncFileName];
    }
}

- (NSString *)syncFileName {
    return [parameters objectForKey:SDLNameSyncFileName];
}

@end
