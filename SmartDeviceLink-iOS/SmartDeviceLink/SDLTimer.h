//
//  SDLTimer.h
//

#import <Foundation/Foundation.h>

@interface SDLTimer : NSObject

@property (nonatomic, copy) void (^elapsedBlock)(void);
@property (nonatomic, copy) void (^canceledBlock)(void);
@property (assign) float duration;

- (instancetype)init;
- (instancetype)initWithDuration:(float)duration __deprecated;
- (instancetype)initWithDuration:(float)duration repeat:(BOOL)repeat;
- (void)start;
- (void)cancel;

@end
