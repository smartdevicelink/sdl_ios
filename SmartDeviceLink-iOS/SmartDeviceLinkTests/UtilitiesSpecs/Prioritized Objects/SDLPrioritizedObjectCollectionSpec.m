//
//  SDLPrioritizedObjectCollectionSpec.m
//  SmartDeviceLink-iOS

#import <UIKit/UIKit.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPrioritizedObjectCollection.h"


QuickSpecBegin(SDLPrioritizedObjectCollectionSpec)

describe(@"a prioritized object collection", ^{
    __block SDLPrioritizedObjectCollection *collection = nil;
    beforeEach(^{
        collection = [[SDLPrioritizedObjectCollection alloc] init];
    });
    
    it(@"should be empty when first created", ^{
        id returnObj = [collection nextObject];
        
        expect(returnObj).to(beNil());
    });
    
    it(@"should ignore adding nil objects", ^{
        id obj = nil;
        [collection addObject:obj withPriority:0];
        
        id returnObj = [collection nextObject];
        expect(returnObj).to(beNil());
    });
    
    it(@"should ignore adding NSNull objects", ^{
        [collection addObject:[NSNull null] withPriority:0];
        
        id returnObj = [collection nextObject];
        expect(returnObj).to(beNil());
    });
    
    it(@"should be able to add and retrieve a single item", ^{
        NSString *string = @"testString";
        [collection addObject:string withPriority:0];
        
        id returnObj = [collection nextObject];
        
        expect(returnObj).to(equal(string));
    });
    
    describe(@"should retrieve higher priority objects first", ^{
        __block id firstObjectOut = nil;
        __block id secondObjectOut = nil;
        __block id thirdObjectOut = nil;
        
        __block NSString *highPriorityString = nil;
        __block NSString *mediumPriorityString = nil;
        __block NSString *lowPriorityString = nil;
        
        beforeEach(^{
            highPriorityString = @"highPriority";
            mediumPriorityString = @"mediumPriority";
            lowPriorityString = @"lowPriority";
            
            // Add them in "incorrect" order to make sure sorting works correctly.
            // Lower numbers indicate higher priority
            [collection addObject:mediumPriorityString withPriority:100];
            [collection addObject:lowPriorityString withPriority:200];
            [collection addObject:highPriorityString withPriority:0];
            
            firstObjectOut = [collection nextObject];
            secondObjectOut = [collection nextObject];
            thirdObjectOut = [collection nextObject];
        });
        
        it(@"should retrieve the highest priority first", ^{
            expect(firstObjectOut).to(equal(highPriorityString));
        });
        
        it(@"should retrieve the medium priority second", ^{
            expect(secondObjectOut).to(equal(mediumPriorityString));
        });
        
        it(@"should retrieve the lowest priority last", ^{
            expect(thirdObjectOut).to(equal(lowPriorityString));
        });
    });
});

QuickSpecEnd
