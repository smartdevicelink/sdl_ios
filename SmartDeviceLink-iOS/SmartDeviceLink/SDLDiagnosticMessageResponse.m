//  SDLDiagnosticMessageResponse.m
//

#import "SDLDiagnosticMessageResponse.h"

#import "SDLNames.h"

@implementation SDLDiagnosticMessageResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_DiagnosticMessage]) {
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
        [parameters setObject:messageDataResult forKey:NAMES_messageDataResult];
    } else {
        [parameters removeObjectForKey:NAMES_messageDataResult];
    }
}

- (NSMutableArray *)messageDataResult {
    return [parameters objectForKey:NAMES_messageDataResult];
}

@end
