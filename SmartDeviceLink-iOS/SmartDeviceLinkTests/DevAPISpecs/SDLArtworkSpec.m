#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLFileType.h"

QuickSpecBegin(SDLArtworkSpec)

describe(@"SDLArtwork", ^{
    __block SDLArtwork *testArtwork = nil;
    
    describe(@"when created", ^{
        context(@"As a PNG", ^{
            __block NSString *testArtworkName = nil;
            __block UIImage *testImage = nil;
            __block SDLArtworkImageFormat testFormat = NSNotFound;
            
            beforeEach(^{
                testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                testArtworkName = @"Test Artwork";
                testFormat = SDLArtworkImageFormatPNG;
                
                testArtwork = [[SDLArtwork alloc] initWithImage:testImage name:testArtworkName persistent:NO asImageFormat:testFormat];
            });
            
            it(@"should correctly store image data", ^{
                expect(testArtwork.data).to(equal(UIImagePNGRepresentation(testImage)));
            });
            
            it(@"should correctly store name", ^{
                expect(testArtwork.name).to(equal(testArtworkName));
            });
            
            it(@"should correctly store format", ^{
                expect(testArtwork.fileType).to(equal([SDLFileType GRAPHIC_PNG]));
            });
            
            it(@"should correctly store persistence", ^{
                expect(@(testArtwork.persistent)).to(equal(@NO));
            });
        });
        
        context(@"As a JPG", ^{
            __block NSString *testArtworkName = nil;
            __block UIImage *testImage = nil;
            __block SDLArtworkImageFormat testFormat = NSNotFound;
            
            beforeEach(^{
                testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                testArtworkName = @"Test Artwork";
                testFormat = SDLArtworkImageFormatJPG;
                
                testArtwork = [[SDLArtwork alloc] initWithImage:testImage name:testArtworkName persistent:NO asImageFormat:testFormat];
            });
            
            it(@"should correctly store image data", ^{
                expect(testArtwork.data).to(equal(UIImageJPEGRepresentation(testImage, 0.85)));
            });
            
            it(@"should correctly store name", ^{
                expect(testArtwork.name).to(equal(testArtworkName));
            });
            
            it(@"should correctly store format", ^{
                expect(testArtwork.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
            });
            
            it(@"should correctly store persistence", ^{
                expect(@(testArtwork.persistent)).to(equal(@NO));
            });
        });
        
        describe(@"to be persistent", ^{
            __block NSString *testArtworkName = nil;
            __block UIImage *testImage = nil;
            __block SDLArtworkImageFormat testFormat = NSNotFound;
            
            beforeEach(^{
                testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                testArtworkName = @"Test Artwork";
                testFormat = SDLArtworkImageFormatPNG;
                
                testArtwork = [[SDLArtwork alloc] initWithImage:testImage name:testArtworkName persistent:YES asImageFormat:testFormat];
            });
            
            it(@"is persistent", ^{
                expect(@(testArtwork.persistent)).to(equal(@YES));
            });
        });
    });
});

QuickSpecEnd
