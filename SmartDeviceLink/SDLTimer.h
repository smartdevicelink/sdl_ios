//
//  SDLTimer.h
//

#import <Foundation/Foundation.h>

@interface SDLTimer : NSObject

@property (copy, nonatomic) void (^elapsedBlock)(void);
@property (copy, nonatomic) void (^canceledBlock)(void);
@property (assign, nonatomic) float duration;

- (instancetype)init;
- (instancetype)initWithDuration:(float)duration __deprecated;
- (instancetype)initWithDuration:(float)duration repeat:(BOOL)repeat;
- (void)start;
- (void)cancel;

@end
