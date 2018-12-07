#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLFileType.h"
#import "SDLImage.h"
#import "SDLStaticIconName.h"

@interface SDLArtwork()
+ (NSString *)sdl_md5HashFromNSData:(NSData *)data;
@end

QuickSpecBegin(SDLArtworkSpec)

describe(@"SDLArtwork Tests", ^{
    __block SDLArtwork *expectedArtwork = nil;
    __block SDLImage *expectedImage = nil;
    __block NSData *expectedImageData = nil;
    __block UIImage *testImagePNG = nil;
    __block UIImage *testImagePNG2 = nil;
    __block UIImage *testImageJPG = nil;
    __block UIImage *testImagePNGTemplate = nil;

    beforeEach(^{
        expectedArtwork = nil;
        expectedImage = nil;
        expectedImageData = nil;

        testImagePNG = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        testImagePNG2 = [UIImage imageNamed:@"TestLockScreenAppIcon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        testImageJPG = [UIImage imageNamed:@"testImageJPG.jpg" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        testImagePNGTemplate = [[UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    });

    context(@"On creation", ^{
        it(@"should init with artworkWithImage:name:asImageFormat:", ^{
            NSString *artworkName = @"Test";
            expectedArtwork = [SDLArtwork artworkWithImage:testImagePNG name:artworkName asImageFormat:SDLArtworkImageFormatPNG];
            SDLArtwork *expected2  = [[SDLArtwork alloc] initWithImage:testImagePNG name:artworkName persistent:NO asImageFormat:SDLArtworkImageFormatPNG];

            expect(expectedArtwork).to(equal(expected2));
        });

        it(@"should init with persistentArtworkWithImage:name:asImageFormat:", ^{
            NSString *artworkName = @"Test";
            expectedArtwork = [SDLArtwork persistentArtworkWithImage:testImagePNG name:artworkName asImageFormat:SDLArtworkImageFormatPNG];
            SDLArtwork *expected2  = [[SDLArtwork alloc] initWithImage:testImagePNG name:artworkName persistent:YES asImageFormat:SDLArtworkImageFormatPNG];

            expect(expectedArtwork).to(equal(expected2));
        });

        it(@"should init with artworkWithImage:asImageFormat:", ^{
            expectedArtwork = [SDLArtwork artworkWithImage:testImagePNG asImageFormat:SDLArtworkImageFormatPNG];
            SDLArtwork *expected2 = [[SDLArtwork alloc] initWithImage:testImagePNG persistent:NO asImageFormat:SDLArtworkImageFormatPNG];

            expect(expectedArtwork).to(equal(expected2));
        });

        it(@"should init with persistentArtworkWithImage:asImageFormat:", ^{
            expectedArtwork = [SDLArtwork persistentArtworkWithImage:testImagePNG asImageFormat:SDLArtworkImageFormatPNG];
            SDLArtwork *expected2 = [[SDLArtwork alloc] initWithImage:testImagePNG persistent:NO asImageFormat:SDLArtworkImageFormatPNG];

            expect(expectedArtwork).to(equal(expected2));
        });

        it(@"should init with artworkWithStaticIcon:", ^{
            SDLStaticIconName icon = SDLStaticIconNameRSS;
            expectedArtwork = [SDLArtwork artworkWithStaticIcon:icon];
            SDLArtwork *expected2 = [[SDLArtwork alloc] initWithStaticIcon:icon];

            expect(expectedArtwork).to(equal(expected2));
        });

        it(@"should init with initWithStaticIcon:", ^{
            SDLStaticIconName icon = SDLStaticIconNameRSS;
            expectedArtwork = [[SDLArtwork alloc] initWithStaticIcon:icon];
            expectedImage = [[SDLImage alloc] initWithStaticIconName:icon];

            expect(expectedArtwork.name).to(equal(icon));
            expect(expectedArtwork.isStaticIcon).to(beTrue());
            expect(expectedArtwork.imageRPC).to(equal(expectedImage));
            expect(expectedArtwork.isTemplate).to(equal(NO));
            expect(expectedArtwork.persistent).to(beFalse());
        });

        describe(@"When setting the image", ^{
            it(@"should set the image data successfully for an image with a name", ^ {
                NSString *imageName = @"testImage";
                expectedImageData = UIImagePNGRepresentation(testImagePNG);
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG name:imageName persistent:true asImageFormat:SDLArtworkImageFormatPNG];
                expectedImage = [[SDLImage alloc] initWithName:imageName isTemplate:NO];

                expect(expectedImageData).to(equal(expectedArtwork.data));
                expect(expectedArtwork.name).to(equal(imageName));
                expect(expectedArtwork.imageRPC).to(equal(expectedImage));
                expect(expectedArtwork.fileType).to(equal(SDLFileTypePNG));
                expect(expectedArtwork.persistent).to(beTrue());
            });

            it(@"should set the image data successfully for an image without a name", ^ {
                expectedImageData = UIImagePNGRepresentation(testImagePNG);
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG persistent:false asImageFormat:SDLArtworkImageFormatPNG];
                expectedImage = [[SDLImage alloc] initWithName:[SDLArtwork sdl_md5HashFromNSData:expectedImageData] isTemplate:NO];

                expect(expectedImageData).to(equal(expectedArtwork.data));
                expect(expectedArtwork.name).to(equal([SDLArtwork sdl_md5HashFromNSData:expectedImageData]));
                expect(expectedArtwork.imageRPC).to(equal(expectedImage));
                expect(expectedArtwork.fileType).to(equal(SDLFileTypePNG));
                expect(expectedArtwork.persistent).to(beFalse());
                expect(expectedArtwork.name.length).to(equal(16));
            });

            it(@"should not set the image data if the image is nil", ^{
                UIImage *testImage = nil;
                expectedImageData = UIImagePNGRepresentation(testImage);
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImage persistent:true asImageFormat:SDLArtworkImageFormatPNG];

                expect(expectedArtwork).to(beNil());
                expect(expectedArtwork.data).to(beNil());
                expect(expectedArtwork.name).to(beNil());
                expect(expectedArtwork.imageRPC).to(beNil());
                expect(expectedArtwork.fileType).to(beNil());
                expect(expectedArtwork.persistent).to(beFalse());
            });

            describe(@"Setting the image data should also set whether or not the image is a template", ^{
                it(@"should be a template if the UIImage is templated", ^{
                    expectedImageData = UIImagePNGRepresentation(testImagePNGTemplate);
                    expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNGTemplate persistent:true asImageFormat:SDLArtworkImageFormatPNG];

                    expect(expectedArtwork.isTemplate).to(beTrue());
                });

                it(@"should not be a template if the UIImage is not templated", ^{
                    expectedImageData = UIImagePNGRepresentation(testImagePNG);
                    expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG persistent:true asImageFormat:SDLArtworkImageFormatPNG];

                    expect(expectedArtwork.isTemplate).to(beFalse());
                });
            });
        });
    });

    context(@"A name created from hashing the image data should be unique to the image", ^{
        __block NSString *expectedName1 = nil;
        __block NSString *expectedName2 = nil;

        beforeEach(^{
            expectedName1 = nil;
            expectedName2 = nil;
        });

        it(@"should create the same name for the same image", ^{
            expectedName1 = [SDLArtwork sdl_md5HashFromNSData:UIImagePNGRepresentation(testImagePNG)];
            expectedName2 = [SDLArtwork sdl_md5HashFromNSData:UIImagePNGRepresentation(testImagePNG)];
            expect(expectedName1).to(equal(expectedName2));
        });

        it(@"should not create the same name for different images", ^{
            expectedName1 = [SDLArtwork sdl_md5HashFromNSData:UIImagePNGRepresentation(testImagePNG)];
            expectedName2 = [SDLArtwork sdl_md5HashFromNSData:UIImagePNGRepresentation(testImagePNG2)];
            expect(expectedName1).toNot(equal(expectedName2));
        });
    });
});

QuickSpecEnd
