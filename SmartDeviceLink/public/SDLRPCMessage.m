//  SDLRPCMessage.m
//


#import "SDLRPCMessage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCMessage ()

@property (strong, nonatomic, readwrite) NSString *messageType;
@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *function;

@end


@implementation SDLRPCMessage

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (!self) {
        return nil;
    }

    _function = [NSMutableDictionary dictionaryWithCapacity:3];
    _parameters = [NSMutableDictionary dictionary];
    _messageType = SDLRPCParameterNameRequest;
    self.store[_messageType] = _function;

    _function[SDLRPCParameterNameParameters] = _parameters;
    _function[SDLRPCParameterNameOperationName] = name;
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    NSEnumerator *enumerator = [self.store keyEnumerator];
    while (_messageType = [enumerator nextObject]) {
        if (![_messageType isEqualToString:SDLRPCParameterNameBulkData]) {
            break;
        }
    }

    if (_messageType != nil) {
        self.store[_messageType] = [self.store[_messageType] mutableCopy];
        _function = self.store[_messageType];

        _function[SDLRPCParameterNameParameters] = [_function[SDLRPCParameterNameParameters] mutableCopy];
        _parameters = _function[SDLRPCParameterNameParameters];
    }

    _bulkData = dict[SDLRPCParameterNameBulkData];
    
    return self;
}
#pragma clang diagnostic pop

- (nullable NSString *)getFunctionName {
    return self.name;
}

- (void)setFunctionName:(nullable NSString *)functionName {
    [_function sdl_setObject:functionName forName:SDLRPCParameterNameOperationName];
}

- (nullable NSObject *)getParameters:(NSString *)functionName {
    return [_parameters sdl_objectForName:functionName ofClass:NSObject.class error:nil];
}

- (void)setParameters:(NSString *)functionName value:(nullable NSObject *)value {
    [_parameters sdl_setObject:value forName:functionName];
}

- (NSString *)name {
    return [_function sdl_objectForName:SDLRPCParameterNameOperationName ofClass:NSString.class error:nil];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@ (%@)\n%@", self.name, self.messageType, self.parameters];

    return description;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLRPCMessage *newMessage = [[self.class allocWithZone:zone] initWithDictionary:self.store];

    return newMessage;
}

@end

NS_ASSUME_NONNULL_END
