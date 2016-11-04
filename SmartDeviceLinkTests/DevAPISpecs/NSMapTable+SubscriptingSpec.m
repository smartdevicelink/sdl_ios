#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "NSMapTable+Subscripting.h"

QuickSpecBegin(NSMapTable_SubscriptingSpec)

describe(@"A map table with the subscripting category imported", ^{
    __block NSMapTable *testMapTable = nil;
    
    beforeEach(^{
        testMapTable = [NSMapTable strongToStrongObjectsMapTable];
    });
    
    describe(@"adding an object", ^{
        __block NSString *testKey = nil;
        __block NSString *testObject = nil;
        
        beforeEach(^{
            testKey = @"Key";
            testObject = @"Object";
            
            testMapTable[testKey] = testObject;
        });
        
        it(@"should properly add the key and object", ^{
            expect(testMapTable[testKey]).to(equal(testObject));
        });
    });
});

QuickSpecEnd
