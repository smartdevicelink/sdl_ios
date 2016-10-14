//
//  SDLFileTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"

QuickSpecBegin(SDLFileTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLFileTypeBMP).to(equal(@"GRAPHIC_BMP"));
        expect(SDLFileTypeJPEG).to(equal(@"GRAPHIC_JPEG"));
        expect(SDLFileTypePNG).to(equal(@"GRAPHIC_PNG"));
        expect(SDLFileTypeWAV).to(equal(@"AUDIO_WAVE"));
        expect(SDLFileTypeMP3).to(equal(@"AUDIO_MP3"));
        expect(SDLFileTypeAAC).to(equal(@"AUDIO_AAC"));
        expect(SDLFileTypeBinary).to(equal(@"BINARY"));
        expect(SDLFileTypeJSON).to(equal(@"JSON"));
    });
});

QuickSpecEnd
