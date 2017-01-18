//  SDLRPCMessage.h
//

#import "SDLEnum.h"

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCMessage : SDLRPCStruct {
    NSMutableDictionary<NSString *, id> *function;
    NSMutableDictionary<NSString *, id> *parameters;
    NSString *messageType;
}

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;
- (nullable NSString *)getFunctionName;
- (void)setFunctionName:(nullable NSString *)functionName;
- (nullable NSObject *)getParameters:(NSString *)functionName;
- (void)setParameters:(NSString *)functionName value:(nullable NSObject *)value;

@property (nullable, strong) NSData *bulkData;
@property (strong, readonly) NSString *name;
@property (strong, readonly) NSString *messageType;

@end

NS_ASSUME_NONNULL_END
