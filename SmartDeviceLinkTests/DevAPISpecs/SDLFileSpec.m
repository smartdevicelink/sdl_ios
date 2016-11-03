#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFile.h"
#import "SDLFileType.h"


QuickSpecBegin(SDLFileSpec)

describe(@"SDLFile", ^{
    __block SDLFile *testFile = nil;
    
    context(@"when created with data", ^{
        __block NSData *testData = nil;
        __block NSString *testName = nil;
        __block NSString *testFileType = nil;
        __block BOOL testPersistence = NO;
        
        context(@"using test data", ^{
            testName = @"Example Name";
            testData = [@"Example Data" dataUsingEncoding:NSUTF8StringEncoding];
            testFileType = @"mp3";
            testPersistence = YES;
            
            beforeEach(^{
                testFile = [[SDLFile alloc] initWithData:testData name:testName fileExtension:testFileType persistent:testPersistence];
            });
            
            it(@"should not store the data in a temp file", ^{
                expect(testFile.fileURL).to(beNil());
                expect(@([[NSFileManager defaultManager] fileExistsAtPath:testFile.fileURL.path])).to(beFalsy());
            });
            
            it(@"should correctly store data", ^{
                expect(testFile.data).to(equal(testData));
            });
            
            it(@"should correctly store name", ^{
                expect(testFile.name).to(equal(testName));
            });
            
            it(@"should correctly store file type", ^{
                expect(testFile.fileType).to(equal([SDLFileType AUDIO_MP3]));
            });
            
            it(@"should correctly start as non-overwrite", ^{
                expect(@(testFile.overwrite)).to(equal(@NO));
            });
        });
    });
    
    context(@"when created with a file", ^{
        __block NSURL *testFileURL = nil;
        __block NSString *testFileName = nil;
        
        context(@"when created with a non-extant file url", ^{
            beforeEach(^{
                NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                testFileURL = [testBundle URLForResource:@"imageThatDoesNotExist" withExtension:@"jpg"];
                testFileName = @"someImage";
                
                testFile = [[SDLFile alloc] initWithFileURL:testFileURL name:testFileName persistent:NO];
            });
            
            it(@"should be nil", ^{
                expect(testFile).to(beNil());
            });
        });
        
        context(@"when created with an extant file url", ^{
            context(@"that is ephemeral", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImageJPG" withExtension:@"jpg"];
                    testFileName = @"someImage";
                    
                    testFile = [SDLFile fileAtFileURL:testFileURL name:testFileName];
                });
                
                it(@"should correctly store data", ^{
                    expect(testFile.data).to(equal([NSData dataWithContentsOfURL:testFileURL]));
                });
                
                it(@"should correctly store name", ^{
                    expect(testFile.name).to(match(testFileName));
                });
                
                it(@"should correctly store file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
                });
                
                it(@"should correctly store persistence", ^{
                    expect(@(testFile.persistent)).to(equal(@NO));
                });
                
                it(@"should correctly start as non-overwrite", ^{
                    expect(@(testFile.overwrite)).to(equal(@NO));
                });
            });
            
            context(@"That is persistent", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImageJPG" withExtension:@"jpg"];
                    testFileName = @"someImage";
                    
                    testFile = [SDLFile persistentFileAtFileURL:testFileURL name:testFileName];
                });
                
                it(@"should correctly store data", ^{
                    expect(testFile.data).to(equal([NSData dataWithContentsOfURL:testFileURL]));
                });
                
                it(@"should correctly store name", ^{
                    expect(testFile.name).to(equal(testFileName));
                });
                
                it(@"should correctly store file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
                });
                
                it(@"should correctly store persistence", ^{
                    expect(@(testFile.persistent)).to(equal(@YES));
                });
                
                it(@"should correctly start as non-overwrite", ^{
                    expect(@(testFile.overwrite)).to(equal(@NO));
                });
            });
        });
        
        describe(@"it should recognize file of type", ^{
            context(@"jpg", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImageJPG" withExtension:@"jpg"];
                    testFileName = @"someJPG";
                    
                    testFile = [[SDLFile alloc] initWithFileURL:testFileURL name:testFileName persistent:NO];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
                });
            });
            
            context(@"jpeg", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImageJPEG" withExtension:@"jpeg"];
                    testFileName = @"someJPEG";
                    
                    testFile = [[SDLFile alloc] initWithFileURL:testFileURL name:testFileName persistent:NO];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
                });
            });
            
            context(@"png", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImagePNG" withExtension:@"png"];
                    testFileName = @"somePNG";
                    
                    testFile = [[SDLFile alloc] initWithFileURL:testFileURL name:testFileName persistent:NO];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_PNG]));
                });
            });
            
            context(@"bmp", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImageBMP" withExtension:@"bmp"];
                    testFileName = @"someBMP";
                    
                    testFile = [[SDLFile alloc] initWithFileURL:testFileURL name:testFileName persistent:NO];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_BMP]));
                });
            });
            
            context(@"json", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testFileJSON" withExtension:@"json"];
                    testFileName = @"someJSON";
                    
                    testFile = [[SDLFile alloc] initWithFileURL:testFileURL name:testFileName persistent:NO];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType JSON]));
                });
            });
            
            context(@"binary", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImageTIFF" withExtension:@"tiff"];
                    testFileName = @"someTIFF";
                    
                    testFile = [[SDLFile alloc] initWithFileURL:testFileURL name:testFileName persistent:NO];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType BINARY]));
                });
            });
        });
    });
});

QuickSpecEnd
