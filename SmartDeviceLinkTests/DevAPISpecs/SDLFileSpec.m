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
        __block unsigned long long testFileSize = 0.0;

        context(@"using data", ^{
            testName = @"Example Name";
            testData = [@"Example Data" dataUsingEncoding:NSUTF8StringEncoding];
            testFileSize = testData.length;
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

            it(@"should correctly return the file size of the data", ^{
                expect(testFile.fileSize).to(equal(testFileSize));
            });

            it(@"should correctly store persistance", ^{
                expect(testFile.persistent).to(equal(@YES));
            });
            
            it(@"should correctly store name", ^{
                expect(testFile.name).to(equal(testName));
            });
            
            it(@"should correctly store file type", ^{
                expect(testFile.fileType).to(equal(SDLFileTypeMP3));
            });
            
            it(@"should correctly start as non-overwrite", ^{
                expect(@(testFile.overwrite)).to(equal(@NO));
            });

            it(@"should correctly create an input stream", ^{
                expect(testFile.inputStream).toNot(beNil());
            });
        });
    });
    
    context(@"when created with a file url", ^{
        __block NSURL *testFileURL = nil;
        __block NSString *testFileName = nil;
        __block unsigned long long testFileSize = 0.0;

        context(@"when created with a non-extant file url", ^{
            beforeEach(^{
                NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                testFileURL = [testBundle URLForResource:@"imageThatDoesNotExist" withExtension:@"jpg"];
                testFileName = @"someImage";
                testFile = [[SDLFile alloc] initWithFileURL:testFileURL name:testFileName persistent:NO];
            });
            
            it(@"it should be nil", ^{
                expect(testFile).to(beNil());
            });
        });
        
        context(@"when created with an extant file url", ^{
            context(@"that is ephemeral", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImageJPG" withExtension:@"jpg"];
                    testFileName = @"someImage";
                    testFileSize = [NSData dataWithContentsOfFile:testFileURL.path].length;
                    testFile = [SDLFile fileAtFileURL:testFileURL name:testFileName];
                });

                it(@"should correctly store the file url", ^{
                    expect(testFile.fileURL).to(equal(testFileURL));
                });

                it(@"should not store any data", ^{
                    expect(testFile.data.length).to(beGreaterThan(0));
                });

                it(@"should correctly return the file size of the data stored at the url path", ^{
                    expect(testFile.fileSize).to(equal(testFileSize));
                });

                it(@"should correctly store the file name", ^{
                    expect(testFile.name).to(match(testFileName));
                });
                
                it(@"should correctly store the file type", ^{
                    expect(testFile.fileType).to(equal(SDLFileTypeJPEG));
                });
                
                it(@"should correctly store persistence", ^{
                    expect(@(testFile.persistent)).to(equal(@NO));
                });
                
                it(@"should correctly start as non-overwrite", ^{
                    expect(@(testFile.overwrite)).to(equal(@NO));
                });

                it(@"should correctly create an input stream", ^{
                    expect(testFile.inputStream).toNot(beNil());
                });
            });
            
            context(@"That is persistent", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFileURL = [testBundle URLForResource:@"testImageJPG" withExtension:@"jpg"];
                    testFileName = @"someImage";
                    testFileSize = [NSData dataWithContentsOfFile:testFileURL.path].length;
                    testFile = [SDLFile persistentFileAtFileURL:testFileURL name:testFileName];
                });

                it(@"should correctly store the file url", ^{
                    expect(testFile.fileURL).to(equal(testFileURL));
                });

                it(@"should not store any data", ^{
                    expect(testFile.data.length).to(beGreaterThan(0));
                });

                it(@"should correctly return the file size of the data stored at the url path", ^{
                    expect(testFile.fileSize).to(equal(testFileSize));
                });

                it(@"should correctly store name", ^{
                    expect(testFile.name).to(equal(testFileName));
                });
                
                it(@"should correctly store file type", ^{
                    expect(testFile.fileType).to(equal(SDLFileTypeJPEG));
                });
                
                it(@"should correctly store persistence", ^{
                    expect(@(testFile.persistent)).to(equal(@YES));
                });
                
                it(@"should correctly start as non-overwrite", ^{
                    expect(@(testFile.overwrite)).to(equal(@NO));
                });

                it(@"should correctly create an input stream", ^{
                    expect(testFile.inputStream).toNot(beNil());
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
                    expect(testFile.fileType).to(equal(SDLFileTypeJPEG));
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
                    expect(testFile.fileType).to(equal(SDLFileTypeJPEG));
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
                    expect(testFile.fileType).to(equal(SDLFileTypePNG));
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
                    expect(testFile.fileType).to(equal(SDLFileTypeBMP));
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
                    expect(testFile.fileType).to(equal(SDLFileTypeJSON));
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
                    expect(testFile.fileType).to(equal(SDLFileTypeBinary));
                });
            });

            // FIXME: - Add test cases for audio file types
            context(@"wav", ^{

            });

            context(@"mp3", ^{

            });

            context(@"aac", ^{

            });
        });
    });
});

QuickSpecEnd
