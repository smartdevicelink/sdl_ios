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

@property (strong, nonatomic) NSData *bulkData;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *messageType;

@end
