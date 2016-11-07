//  SDLRPCMessage.m
//


#import "SDLRPCMessage.h"

#import "SDLNames.h"

@implementation SDLRPCMessage

@synthesize messageType;

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        function = [[NSMutableDictionary alloc] initWithCapacity:3];
        parameters = [[NSMutableDictionary alloc] init];
        messageType = SDLNameRequest;
        [store setObject:function forKey:messageType];
        [function setObject:parameters forKey:SDLNameParameters];
        [function setObject:name forKey:SDLNameOperationName];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        NSEnumerator *enumerator = [store keyEnumerator];
        while (messageType = [enumerator nextObject]) {
            if ([messageType isEqualToString:SDLNameBulkData] == FALSE) {
                break;
            }
        }
        if (messageType != nil) {
            function = [store objectForKey:messageType];
            parameters = [function objectForKey:SDLNameParameters];
        }
        self.bulkData = [dict objectForKey:SDLNameBulkData];
    }
    
    return self;
}

- (NSString *)getFunctionName {
    return [self objectForName:SDLNameOperationName fromStorage:function];
}

- (void)setFunctionName:(NSString *)functionName {
    [self setObject:functionName forName:SDLNameOperationName inStorage:function];
}

- (NSObject *)getParameters:(NSString *)functionName {
    return [self objectForName:functionName];
}

- (void)setParameters:(NSString *)functionName value:(NSObject *)value {
    [self setObject:value forName:functionName];
}

- (void)dealloc {
    function = nil;
    parameters = nil;
}

- (NSString *)name {
    return [self getFunctionName];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@ (%@)\n%@", self.name, self.messageType, self->parameters];

    return description;
}

#pragma mark - Overrides
- (void)setObject:(NSObject *)object forName:(SDLName)name {
    [self setObject:object forName:name inStorage:parameters];
}

- (id)objectForName:(SDLName)name {
    return [self objectForName:name fromStorage:parameters];
}

@end
