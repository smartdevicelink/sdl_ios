//
//  SDLTimer.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLTimer : NSObject

@property (nullable, nonatomic, copy) void (^elapsedBlock)(void);
@property (nullable, nonatomic, copy) void (^canceledBlock)(void);
@property (assign) float duration;

- (instancetype)init;
- (instancetype)initWithDuration:(float)duration __deprecated;
- (instancetype)initWithDuration:(float)duration repeat:(BOOL)repeat;
- (void)start;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
