//  SDLRPCMessage.m
//


#import "SDLRPCMessage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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
            if (![messageType isEqualToString:SDLNameBulkData]) {
                break;
            }
        }
        if (messageType != nil) {
            store[messageType] = [store[messageType] mutableCopy];
            function = store[messageType];

            function[SDLNameParameters] = [function[SDLNameParameters] mutableCopy];
            parameters = function[SDLNameParameters];
        }
        self.bulkData = dict[SDLNameBulkData];
    }
    
    return self;
}

- (nullable NSString *)getFunctionName {
    return [function sdl_objectForName:SDLNameOperationName];
}

- (void)setFunctionName:(nullable NSString *)functionName {
    [function sdl_setObject:functionName forName:SDLNameOperationName];
}

- (nullable NSObject *)getParameters:(NSString *)functionName {
    return [parameters sdl_objectForName:functionName];
}

- (void)setParameters:(NSString *)functionName value:(nullable NSObject *)value {
    [parameters sdl_setObject:value forName:functionName];
}

- (NSString *)name {
    return [self getFunctionName];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@ (%@)\n%@", self.name, self.messageType, self->parameters];

    return description;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLRPCMessage *newMessage = [[self.class allocWithZone:zone] initWithDictionary:self->store];

    return newMessage;
}

@end

NS_ASSUME_NONNULL_END
