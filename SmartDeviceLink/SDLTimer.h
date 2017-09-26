//
//  SDLTimer.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLTimer : NSObject

@property (copy, nonatomic, nullable) void (^elapsedBlock)(void);
@property (copy, nonatomic, nullable) void (^canceledBlock)(void);
@property (assign, nonatomic) float duration;

- (instancetype)init;
- (instancetype)initWithDuration:(float)duration;
- (instancetype)initWithDuration:(float)duration repeat:(BOOL)repeat;
- (void)start;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
