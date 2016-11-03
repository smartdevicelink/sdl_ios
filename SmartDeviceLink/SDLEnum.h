//  SDLEnum.h
//


#import <Foundation/Foundation.h>


@interface SDLEnum : NSObject <NSCopying> {
    NSString *value;
}

- (instancetype)initWithValue:(NSString *)value;

- (BOOL)isEqualToEnum:(SDLEnum *)object;

@property (strong, readonly) NSString *value;

@end
