//
//  SDLPrioritizedObjectCollectionSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/26/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

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
    
    it(@"should be able to add and retrieve a single item", ^{
        NSString *string = @"testString";
        [collection addObject:string withPriority:0];
        
        id object = [collection nextObject];
        
        expect(object).to(equal(string));
    });
    
    it(@"should retrieve higher priority objects first", ^{
        NSString *highPriorityString = @"highPriority";
        NSString *mediumPriorityString = @"mediumPriority";
        NSString *lowPriorityString = @"lowPriority";
        
        // Add them in "incorrect" order to make sure sorting works correctly
        [collection addObject:mediumPriorityString withPriority:100];
        [collection addObject:highPriorityString withPriority:200];
        [collection addObject:lowPriorityString withPriority:0];
        
        id firstObjectOut = [collection nextObject];
        id secondObjectOut = [collection nextObject];
        id thirdObjectOut = [collection nextObject];
        
        expect(firstObjectOut).to(equal(highPriorityString));
        expect(secondObjectOut).to(equal(mediumPriorityString));
        expect(thirdObjectOut).to(equal(lowPriorityString));
    });
});

QuickSpecEnd
