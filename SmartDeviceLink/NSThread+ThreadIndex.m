//
//  NSThread+ThreadIndex.m
//

#import "NSThread+ThreadIndex.h"

@implementation NSThread (ThreadIndex)

- (NSInteger)threadIndex {
    NSString *description = [self description];
    NSArray<NSString *> *keyValuePairs = [description componentsSeparatedByString:@","];
    for (NSString *keyValuePair in keyValuePairs) {
        NSArray<NSString *> *components = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = components[0];
        key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([key rangeOfString:@"num"].location != NSNotFound) {
            return [components[1] integerValue];
        }
    }
    return -1;
}

@end
