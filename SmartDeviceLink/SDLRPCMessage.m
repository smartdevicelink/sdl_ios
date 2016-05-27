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
        messageType = NAMES_request;
        [store setObject:function forKey:messageType];
        [function setObject:parameters forKey:NAMES_parameters];
        [function setObject:name forKey:NAMES_operation_name];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        NSEnumerator *enumerator = [store keyEnumerator];
        while (messageType = [enumerator nextObject]) {
            if ([messageType isEqualToString:@"bulkData"] == FALSE) {
                break;
            }
        }

        function = [store objectForKey:messageType];
        parameters = [function objectForKey:NAMES_parameters];
        self.bulkData = [dict objectForKey:@"bulkData"];
    }
    return self;
}

- (NSString *)getFunctionName {
    return [function objectForKey:NAMES_operation_name];
}

- (void)setFunctionName:(NSString *)functionName {
    if (functionName != nil) {
        [function setObject:functionName forKey:NAMES_operation_name];
    } else {
        [function removeObjectForKey:NAMES_operation_name];
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
    return [function objectForKey:NAMES_operation_name];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@ (%@)\n%@", self.name, self.messageType, self->parameters];

    return description;
}

@end
