//  SDLDiagnosticMessageResponse.m
//

#import "SDLDiagnosticMessageResponse.h"

#import "SDLNames.h"

@implementation SDLDiagnosticMessageResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameDiagnosticMessage]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setMessageDataResult:(NSMutableArray *)messageDataResult {
    if (messageDataResult != nil) {
        [parameters setObject:messageDataResult forKey:SDLNameMessageDataResult];
    } else {
        [parameters removeObjectForKey:SDLNameMessageDataResult];
    }
}

- (NSMutableArray *)messageDataResult {
    return [parameters objectForKey:SDLNameMessageDataResult];
}

@end
