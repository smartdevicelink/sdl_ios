@import Quick;
@import Nimble;

#import "NSMutableDictionary+Store.h"

@interface TestObject : NSObject
@property (nonatomic, strong, nullable) NSDictionary *json;
- (instancetype)initWithDictionary:(NSDictionary *)json;
@end

@implementation TestObject
- (instancetype)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.json = json;
    }
    return self;
}
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[TestObject class]]) {
        return false;
    }
    TestObject *anotherObject = (TestObject *)object;
    return [self.json isEqual:anotherObject.json];
}
@end

QuickSpecBegin(NSMutableDictionary_StoreSpec)

describe(@"A mutable dictionary with the storing category imported", ^{
    __block NSMutableDictionary *testDictionary = nil;
    __block NSString *testKey = @"Key";

    beforeEach(^{
        testDictionary = [[NSMutableDictionary alloc] init];
    });

    describe(@"retrieving a string", ^{
        __block NSString *testObject = @"Object";

        beforeEach(^{
            [testDictionary sdl_setObject:testObject forName:testKey];
        });

        it(@"should return string when called correctly", ^{
            expect([testDictionary sdl_objectForName:testKey ofClass:[NSString class] error:nil]).to(equal(testObject));
        });

        it(@"should raise an exception when called with wrong class type", ^{
            expectAction(^{
                [testDictionary sdl_objectForName:testKey ofClass:[NSNumber class] error:nil];
            }).to(raiseException());
        });
    });

    describe(@"retrieving a single object", ^{
        __block NSString *testObject = @"Object";

        beforeEach(^{
            [testDictionary sdl_setObject:testObject forName:testKey];
        });

        it(@"should return nil and raise an exception when retrieved as an array", ^{
            expectAction(^{
                [testDictionary sdl_objectsForName:testKey ofClass:[NSString class] error:nil];
            }).to(raiseException());
        });
    });

    describe(@"Retrieving a custom JSON object", ^{
        __block TestObject *testObject = nil;
        beforeEach(^{
            NSDictionary *testJson = @{};
            testObject = [[TestObject alloc] initWithDictionary:testJson];
            [testDictionary sdl_setObject:testJson forName:testKey];
        });

        it(@"should return the object correctly when retrieved correctly", ^{
            expect([testDictionary sdl_objectForName:testKey ofClass:[TestObject class] error:nil]).to(equal(testObject));
        });

        it(@"should raise an exception when retrieved as an NSNumber", ^{
            expectAction(^{
                [testDictionary sdl_objectForName:testKey ofClass:[NSNumber class] error:nil];
            }).to(raiseException());
        });
    });

    describe(@"Retrieving an array of one string", ^{
        __block NSString *testObject = @"Object";
        __block NSArray<NSString *> *testObjectArray = @[testObject];

        beforeEach(^{
            [testDictionary sdl_setObject:testObjectArray forName:testKey];
        });

        it(@"should raise an exception when retrieved as an NSString", ^{
            expectAction(^{
                [testDictionary sdl_objectForName:testKey ofClass:[NSString class] error:nil];
            }).to(raiseException());
        });

        it(@"should return correctly when retrieved correctly", ^{
            expect([testDictionary sdl_objectsForName:testKey ofClass:[NSString class] error:nil]).to(equal(testObjectArray));
        });

        it(@"should raise an exception when retrieved as an NSNumber", ^{
            expectAction(^{
                [testDictionary sdl_objectForName:testKey ofClass:[NSNumber class] error:nil];
                [testDictionary sdl_objectsForName:testKey ofClass:[NSNumber class] error:nil];
            }).to(raiseException());
        });
    });

    describe(@"retrieving an array of custom objects", ^{
        __block NSArray<TestObject *> *testObjectArray = nil;

        beforeEach(^{
            NSDictionary *testJson = @{};
            TestObject *testObject = [[TestObject alloc] initWithDictionary:testJson];
            NSArray<NSDictionary *> *testJsonArray = @[testJson];
            testObjectArray = @[testObject];
            [testDictionary sdl_setObject:testJsonArray forName:testKey];
        });

        it(@"should return correctly when retrieved correctly", ^{
            expect([testDictionary sdl_objectsForName:testKey ofClass:[TestObject class] error:nil]).to(equal(testObjectArray));
        });

        it(@"should raise an exception when retrieved as an NSNumber", ^{
            expectAction(^{
                [testDictionary sdl_objectsForName:testKey ofClass:[NSNumber class] error:nil];
            }).to(raiseException());
        });
    });

    describe(@"Retrieving an SDLEnum", ^{
        __block SDLEnum testObject = @"Object";

        beforeEach(^{
            [testDictionary sdl_setObject:testObject forName:testKey];
        });

        it(@"should return correctly when retrieved correctly", ^{
            expect([testDictionary sdl_enumForName:testKey error:nil]).to(equal(testObject));
        });

        it(@"should raise an exception when retrieved as an array", ^{
            expectAction(^{
                [testDictionary sdl_enumsForName:testKey error:nil];
            }).to(raiseException());
        });
    });

    describe(@"retrieving an array of SDLEnums", ^{
        __block NSArray<SDLEnum> *testObjectArray = nil;

        beforeEach(^{
            __block SDLEnum testObject = @"Object";
            testObjectArray = @[testObject];
            [testDictionary sdl_setObject:testObjectArray forName:testKey];
        });

        it(@"should return an array of SDLEnum when retrieved correctly", ^{
            expect([testDictionary sdl_enumsForName:testKey error:nil]).to(equal(testObjectArray));
        });

        it(@"should raise an exception when retrieved as an NSNumber", ^{
            expectAction(^{
                [testDictionary sdl_objectForName:testKey ofClass:[NSNumber class] error:nil];
            }).to(raiseException());
        });
    });
});

QuickSpecEnd
