//  SDLRPCMessage.h
//

#import "SDLEnum.h"

#import "SDLRPCStruct.h"

@interface SDLRPCMessage : SDLRPCStruct {
    NSMutableDictionary<NSString *, id> *function;
    NSMutableDictionary<NSString *, id> *parameters;
    NSString *messageType;
}

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;
- (NSString *)getFunctionName;
- (void)setFunctionName:(NSString *)functionName;
- (NSObject *)getParameters:(NSString *)functionName;
- (void)setParameters:(NSString *)functionName value:(NSObject *)value;

@property (strong) NSData *bulkData;
@property (strong, readonly) NSString *name;
@property (strong, readonly) NSString *messageType;

@end
