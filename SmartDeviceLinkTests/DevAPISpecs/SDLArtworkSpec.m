#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLFileType.h"

@interface SDLArtwork()
+ (NSString *)sdl_md5HashFromNSData:(NSData *)data;
@end

QuickSpecBegin(SDLArtworkSpec)

describe(@"SDLArtwork", ^{
    __block SDLArtwork *expectedArtwork = nil;
    __block UIImage *testImagePNG = nil;
    __block UIImage *testImagePNG2 = nil;
    __block UIImage *testImageJPG = nil;

    beforeEach(^{
        testImagePNG = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        testImagePNG2 = [UIImage imageNamed:@"TestLockScreenAppIcon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        testImageJPG = [UIImage imageNamed:@"testImageJPG.jpg" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    });

    context(@"On creation", ^{
        describe(@"When setting the image", ^{
            __block NSData *expectedImageData = nil;

            it(@"should set the image data successfully for an image with a name", ^ {
                expectedImageData = UIImagePNGRepresentation(testImagePNG);
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG name:@"testImage" persistent:true asImageFormat:SDLArtworkImageFormatPNG];
            });

            it(@"should set the image data successfully for an image without a name", ^ {
                expectedImageData = UIImagePNGRepresentation(testImagePNG);
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG persistent:true asImageFormat:SDLArtworkImageFormatPNG];
            });

            it(@"should not set the image data if the image is nil", ^{
                UIImage *testImage = nil;
                expectedImageData = UIImagePNGRepresentation(testImage);
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImage persistent:true asImageFormat:SDLArtworkImageFormatPNG];
            });

            afterEach(^{
                if (expectedImageData == nil) {
                    expect(expectedArtwork.data).to(beNil());
                } else {
                    expect(expectedImageData).to(equal(expectedArtwork.data));
                }
            });
        });

        describe(@"When setting the name", ^{
            __block NSString *expectedName = nil;

            it(@"should set the passed name correctly", ^{
                NSString *imageName = @"TestImageName";
                expectedName = imageName;
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG name:imageName persistent:true asImageFormat:SDLArtworkImageFormatPNG];
            });

            context(@"When no name is provided", ^{
                it(@"should create a unique name based on the hash of the image", ^{
                    expectedName = [SDLArtwork sdl_md5HashFromNSData:UIImagePNGRepresentation(testImagePNG)];
                    expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG persistent:true asImageFormat:SDLArtworkImageFormatPNG];
                });

                it(@"should create an empty string if the image is nil", ^{
                    UIImage *testNilImage = nil;
                    expectedName = @"";
                    expectedArtwork = [[SDLArtwork alloc] initWithImage:testNilImage persistent:true asImageFormat:SDLArtworkImageFormatPNG];
                });
            });

            afterEach(^{
                if (expectedName.length == 0) {
                    expect(expectedArtwork.name).to(beNil());
                } else {
                    expect(expectedName).to(equal(expectedArtwork.name));
                }
            });
        });

        describe(@"When setting the image format", ^{
            __block SDLFileType expectedImageFormat = nil;
            __block NSData *expectedImageData = nil;

            it(@"should create a PNG image successfully", ^{
                expectedImageFormat = SDLFileTypePNG;
                expectedImageData = UIImagePNGRepresentation(testImagePNG);
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG name:@"testImagePNG" persistent:true asImageFormat:SDLArtworkImageFormatPNG];
            });

            it(@"should create a JPG image successfully", ^{
                expectedImageFormat = SDLFileTypeJPEG;
                expectedImageData = UIImageJPEGRepresentation(testImageJPG, 0.85);
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImageJPG name:@"testImageJPG" persistent:true asImageFormat:SDLArtworkImageFormatJPG];
            });

            afterEach(^{
                expect(expectedImageFormat).to(equal(expectedArtwork.fileType));
                expect(expectedImageData).to(equal(expectedArtwork.data));
            });
        });

        describe(@"When setting the image persistence", ^{
            __block Boolean expectedPersistance = false;

            it(@"should set the image persistence to ephemeral successfully", ^{
                Boolean persistance = false;
                expectedPersistance = persistance;
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG name:@"testImagePNG" persistent:persistance asImageFormat:SDLArtworkImageFormatPNG];
            });

            it(@"should set the image persistence to permanent successfully", ^{
                Boolean persistance = true;
                expectedPersistance = persistance;
                expectedArtwork = [[SDLArtwork alloc] initWithImage:testImagePNG name:@"testImagePNG" persistent:persistance asImageFormat:SDLArtworkImageFormatPNG];
            });

            afterEach(^{
                expect(expectedPersistance).to(equal(expectedArtwork.persistent));
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
