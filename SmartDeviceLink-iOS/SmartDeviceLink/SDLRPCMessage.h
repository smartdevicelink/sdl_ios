//  SDLRPCMessage.h
//

#import "SDLEnum.h"

#import "SDLRPCStruct.h"

@interface SDLRPCMessage : SDLRPCStruct {
    NSMutableDictionary *function;
    NSMutableDictionary *parameters;
    NSString *messageType;
}

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;
- (NSString *)getFunctionName;
- (void)setFunctionName:(NSString *)functionName;
- (NSObject *)getParameters:(NSString *)functionName;
- (void)setParameters:(NSString *)functionName value:(NSObject *)value;

@property (strong) NSData *bulkData;
@property (strong, readonly) NSString *name;
@property (strong, readonly) NSString *messageType;

@end
