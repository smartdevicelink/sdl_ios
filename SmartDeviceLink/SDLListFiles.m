//  SDLListFiles.m
//


#import "SDLListFiles.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLListFiles

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameListFiles]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
