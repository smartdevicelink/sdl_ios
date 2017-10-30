//
//  SDLObjectWithPriority.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLObjectWithPriority : NSObject

@property (nullable, strong, nonatomic) id object;
@property (assign, nonatomic) NSInteger priority;

- (instancetype)initWithObject:(nullable id)object priority:(NSInteger)priority NS_DESIGNATED_INITIALIZER;

+ (instancetype)objectWithObject:(nullable id)object priority:(NSInteger)priority;

@end

NS_ASSUME_NONNULL_END
