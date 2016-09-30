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

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
        NSEnumerator *enumerator = [store keyEnumerator];
        while (messageType = [enumerator nextObject]) {
            if ([messageType isEqualToString:SDLNameBulkData] == FALSE) {
                break;
            }
        }

        if (messageType == nil) {
            return nil;
        }

        function = [store objectForKey:messageType];
        parameters = [function objectForKey:SDLNameParameters];
        self.bulkData = [dict objectForKey:SDLNameBulkData];
    }
    return self;
}

- (NSString *)getFunctionName {
    return [function objectForKey:SDLNameOperationName];
}

- (void)setFunctionName:(NSString *)functionName {
    if (functionName != nil) {
        [function setObject:functionName forKey:SDLNameOperationName];
    } else {
        [function removeObjectForKey:SDLNameOperationName];
    }
}

- (NSObject *)getParameters:(NSString *)functionName {
    return [parameters objectForKey:functionName];
}

- (void)setParameters:(NSString *)functionName value:(NSObject *)value {
    if (value != nil) {
        [parameters setObject:value forKey:functionName];
    } else {
        [parameters removeObjectForKey:functionName];
    }
}

- (void)dealloc {
    function = nil;
    parameters = nil;
}

- (NSString *)name {
    return [function objectForKey:SDLNameOperationName];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@ (%@)\n%@", self.name, self.messageType, self->parameters];

    return description;
}

@end
