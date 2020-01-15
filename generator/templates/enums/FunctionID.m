{% include 'copyright.txt' %}
//  {{name}}.m

#import "{{name}}.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@interface {{name}} ()

@property (nonatomic, strong, nonnull) NSDictionary* functionIds;

@end

@implementation {{name}}

+ (instancetype)sharedInstance {
    static {{name}}* functionId = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        functionId = [[{{name}} alloc] init];
    });
    return functionId;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.functionIds = @{
                         {%- for param in params %}
                         @{{param.value}}: SDLRPCFunctionName{{param.name}}{{ ',' if not loop.last }}
                         {%- endfor %}
                         };
    return self;
}

- (nullable SDLRPCFunctionName)functionNameForId:(UInt32)functionID {
    return self.functionIds[@(functionID)];
}

- (nullable NSNumber<SDLInt> *)functionIdForName:(SDLRPCFunctionName)functionName {
    return [[self.functionIds allKeysForObject:functionName] firstObject];
}

@end

NS_ASSUME_NONNULL_END
