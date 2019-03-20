#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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

    describe(@"adding a string", ^{
        __block NSString *testObject = @"Object";

        beforeEach(^{
            [testDictionary sdl_setObject:testObject forName:testKey];
        });

        it(@"should return string", ^{
            expect([testDictionary sdl_objectForName:testKey ofClass:[NSString class]]).to(equal(testObject));
        });
        it(@"should raise exceprion", ^{
            expectAction(^{
                expect([testDictionary sdl_objectForName:testKey ofClass:[NSNumber class]]).to(beNil());
            }).to(raiseException());
        });
    });

    describe(@"adding a single object", ^{
        __block NSString *testObject = @"Object";

        beforeEach(^{
            [testDictionary sdl_setObject:testObject forName:testKey];
        });

        it(@"should return nil", ^{
            expectAction(^{
                expect([testDictionary sdl_objectsForName:testKey ofClass:[NSString class]]).to(beNil());
            }).to(raiseException());
        });
    });

    describe(@"adding a custom object using JSON", ^{
        __block NSDictionary *testJson = @{};
        __block TestObject *testObject = [[TestObject alloc] initWithDictionary:testJson];

        beforeEach(^{
            [testDictionary sdl_setObject:testJson forName:testKey];
        });

        it(@"should return object", ^{
            expect([testDictionary sdl_objectForName:testKey ofClass:[TestObject class]]).to(equal(testObject));
        });
        it(@"should raise exceprion", ^{
            expectAction(^{
                expect([testDictionary sdl_objectForName:testKey ofClass:[NSNumber class]]).to(beNil());
            }).to(raiseException());
        });
    });

    describe(@"adding an array of strings", ^{
        __block NSString *testObject = @"Object";
        __block NSArray<NSString *> *testObjectArray = @[testObject];

        beforeEach(^{
            [testDictionary sdl_setObject:testObjectArray forName:testKey];
        });

        expectAction(^{
            expect([testDictionary sdl_objectForName:testKey ofClass:[NSString class]]).to(equal(testObject));
        }).to(raiseException());
        it(@"should return array", ^{
            expect([testDictionary sdl_objectsForName:testKey ofClass:[NSString class]]).to(equal(testObjectArray));
        });
        it(@"should raise exceprion", ^{
            expectAction(^{
                expect([testDictionary sdl_objectForName:testKey ofClass:[NSNumber class]]).to(beNil());
                expect([testDictionary sdl_objectsForName:testKey ofClass:[NSNumber class]]).to(beNil());
            }).to(raiseException());
        });
    });

    describe(@"adding an array of custom objects", ^{
        __block NSDictionary *testJson = @{};
        __block TestObject *testObject = [[TestObject alloc] initWithDictionary:testJson];
        __block NSArray<NSDictionary *> *testJsonArray = @[testJson];
        __block NSArray<TestObject *> *testObjectArray = @[testObject];

        beforeEach(^{
            [testDictionary sdl_setObject:testJsonArray forName:testKey];
        });

        it(@"should return array", ^{
            expect([testDictionary sdl_objectsForName:testKey ofClass:[TestObject class]]).to(equal(testObjectArray));
        });
        it(@"should raise exceprion", ^{
            expectAction(^{
                expect([testDictionary sdl_objectsForName:testKey ofClass:[NSNumber class]]).to(beNil());
            }).to(raiseException());
        });
    });

    describe(@"adding a SDLEnum", ^{
        __block SDLEnum testObject = @"Object";

        beforeEach(^{
            [testDictionary sdl_setObject:testObject forName:testKey];
        });

        it(@"should return SDLEnum", ^{
            expect([testDictionary sdl_enumForName:testKey error:nil]).to(equal(testObject));
        });
        it(@"should raise exception", ^{
            expectAction(^{
                expect([testDictionary sdl_enumsForName:testKey error:nil]).to(beNil());
            }).to(raiseException());
        });
    });

    describe(@"adding an array of SDLEnum", ^{
        __block SDLEnum testObject = @"Object";
        __block NSArray<SDLEnum> *testObjectArray = @[testObject];

        beforeEach(^{
            [testDictionary sdl_setObject:testObjectArray forName:testKey];
        });

        it(@"should return array of SDLEnum", ^{
            expect([testDictionary sdl_enumsForName:testKey error:nil]).to(equal(testObjectArray));
        });
        it(@"should raise exceprion", ^{
            expectAction(^{
                expect([testDictionary sdl_objectForName:testKey ofClass:[NSNumber class]]).to(beNil());
            }).to(raiseException());
        });
    });
});

QuickSpecEnd
