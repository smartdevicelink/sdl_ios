//
//  SDLImageSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImage.h"
#import "SDLImageType.h"
#import "SDLNames.h"


QuickSpecBegin(SDLImageSpec)

describe(@"Getter/Setter Tests", ^{
    context(@"When creating", ^{
        __block SDLImage *testSDLImage = nil;
        __block NSString *expectedValue;
        __block SDLImageType expectedImageType;
        __block NSNumber<SDLBool> *expectedIsTemplate;

        beforeEach(^{
            testSDLImage = nil;
            expectedValue = nil;
            expectedImageType = nil;
            expectedIsTemplate = @NO;
        });

        it(@"Should set and get correctly", ^{
            NSString *value = @"value";
            SDLImageType imageType = SDLImageTypeDynamic;

            testSDLImage = [[SDLImage alloc] init];
            testSDLImage.value = value;
            testSDLImage.imageType = imageType;
            testSDLImage.isTemplate = @YES;

            expectedValue = value;
            expectedImageType = imageType;
            expectedIsTemplate = @YES;
        });

        it(@"Should get correctly when initialized as a dictionary", ^{
            NSString *value = @"value";
            SDLImageType imageType = SDLImageTypeStatic;

            NSMutableDictionary* dict = [@{SDLNameValue:value,
                                           SDLNameImageType:imageType,
                                           SDLNameImageTemplate:@YES
                                           } mutableCopy];
            testSDLImage = [[SDLImage alloc] initWithDictionary:dict];

            expectedValue = value;
            expectedImageType = imageType;
            expectedIsTemplate = @YES;
        });

        it(@"Should get correctly when initialized with a name only", ^{
            NSString *name = @"name";
            testSDLImage = [[SDLImage alloc] initWithName:name isTemplate:YES];

            expectedValue = name;
            expectedImageType = SDLImageTypeDynamic;
            expectedIsTemplate = @YES;
        });

        it(@"Should get correctly when initialized with a name and image type", ^{
            NSString *name = @"name";
            testSDLImage = [[SDLImage alloc] initWithName:name ofType:SDLImageTypeDynamic isTemplate:NO];

            expectedValue = name;
            expectedImageType = SDLImageTypeDynamic;
            expectedIsTemplate = @NO;
        });

        it(@"Should get correctly when initialized with static image value", ^{
            UInt16 staticImageValue = 2568;
            testSDLImage = [[SDLImage alloc] initWithStaticImageValue:staticImageValue isTemplate:NO];

            expectedValue = @"2568";
            expectedImageType = SDLImageTypeStatic;
            expectedIsTemplate = @NO;
        });

        afterEach(^{
            expect(testSDLImage.value).to(equal(expectedValue));
            expect(testSDLImage.imageType).to(equal(expectedImageType));
            expect(testSDLImage.isTemplate).to(equal(expectedIsTemplate));
        });
    });

    it(@"Should return nil if not set", ^{
        SDLImage *testSDLImage = [[SDLImage alloc] init];
        expect(testSDLImage.value).to(beNil());
        expect(testSDLImage.imageType).to(beNil());
        expect(testSDLImage.isTemplate).to(beNil());
    });
});

QuickSpecEnd
