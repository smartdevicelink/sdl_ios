//
//  SDLObjectWithPriority.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>


@interface SDLObjectWithPriority : NSObject

@property (strong) id object;
@property (assign) NSInteger priority;

- (instancetype)initWithObject:(id)object priority:(NSInteger)priority NS_DESIGNATED_INITIALIZER;

+ (instancetype)objectWithObject:(id)object priority:(NSInteger)priority;

@end
