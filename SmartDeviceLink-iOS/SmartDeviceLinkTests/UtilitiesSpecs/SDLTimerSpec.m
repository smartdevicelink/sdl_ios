#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTimer.h"


QuickSpecBegin(SDLTimerSpec)

describe(@"Running a timer", ^{
    __block SDLTimer *testTimer = nil;
    __block NSMutableArray *calledTimes = nil;
    
    context(@"which repeats", ^{
        beforeEach(^{
            testTimer = [[SDLTimer alloc] initWithDuration:0.5 repeat:YES];
            calledTimes = [NSMutableArray array];
            
            testTimer.elapsedBlock = ^{
                NSLog(@"Adding Object");
                [calledTimes addObject:[NSDate date]];
            };
            
            [testTimer start];
        });
        
        it(@"should correctly call the elapsed block", ^{
            expect(@(calledTimes.count)).withTimeout(2.1).toEventually(equal(@4));
        });
        
        afterEach(^{
            [testTimer cancel];
        });
    });
});

QuickSpecEnd
