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
        expect(SDLFileTypeGraphicBMP).to(equal(@"GRAPHIC_BMP"));
        expect(SDLFileTypeGraphicJPEG).to(equal(@"GRAPHIC_JPEG"));
        expect(SDLFileTypeGraphicPNG).to(equal(@"GRAPHIC_PNG"));
        expect(SDLFileTypeAudioWAV).to(equal(@"AUDIO_WAVE"));
        expect(SDLFileTypeAudioMP3).to(equal(@"AUDIO_MP3"));
        expect(SDLFileTypeAudioAAC).to(equal(@"AUDIO_AAC"));
        expect(SDLFileTypeBinary).to(equal(@"BINARY"));
        expect(SDLFileTypeJSON).to(equal(@"JSON"));
    });
});

QuickSpecEnd
