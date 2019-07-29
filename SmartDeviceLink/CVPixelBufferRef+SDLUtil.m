//
//  CVPixelBufferRef+SDLUtil.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 3/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "CVPixelBufferRef+SDLUtil.h"
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

// Video stream string message padding is 5% of the screen size. Padding is added to the message so the text is not flush with the edge of the screen.
CGFloat const SDLVideoStringMessagePadding = .05;

UIFont * _Nullable sdl_findFontSizeToFitText(CGSize size, NSString *text) {
    CGFloat fontSize = 300;

    do {
        CGFloat padding = SDLVideoStringMessagePadding * size.width * 2;
        CGSize textSize = [text boundingRectWithSize:CGSizeMake((size.width - padding), CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}
                                             context:nil].size;

        if (textSize.height <= (size.height - padding)) {
            break;
        }
        
        fontSize -= (CGFloat)1.0;
    } while (fontSize > 0.0);

    return (fontSize > 0) ? [UIFont systemFontOfSize:fontSize] : nil;
}

UIImage * _Nullable sdl_createTextImage(NSString *text, CGSize size) {
    UIFont *font = sdl_findFontSizeToFitText(size, text);
    
    if (!font) {
        SDLLogW(@"Text cannot fit inside frame");
        return nil;
    }

    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, frame);
    CGContextSaveGState(context);
    
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary* textAttributes = @{
                                     NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSParagraphStyleAttributeName: textStyle
                                     };
    CGRect textFrame = [text boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:textAttributes
                                          context:nil];

    CGFloat padding = SDLVideoStringMessagePadding * size.width;
    CGRect textInset = CGRectMake(0 + padding,
                                  (frame.size.height - CGRectGetHeight(textFrame)) / 2.0,
                                  frame.size.width - (padding * 2),
                                  frame.size.height - (padding * 2));
    
    [text drawInRect:textInset
      withAttributes:textAttributes];
    
    CGContextRestoreGState(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();

    return image;
}

Boolean CVPixelBufferAddText(CVPixelBufferRef CV_NONNULL pixelBuffer, NSString *text) {
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    UIImage *image = sdl_createTextImage(text, CGSizeMake(width, height));
    if (!image) {
        SDLLogE(@"Could not create text image.");
        return false;
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, width, height,
                                                 8, CVPixelBufferGetBytesPerRow(pixelBuffer), rgbColorSpace,
                                                 kCGBitmapByteOrder32Little |
                                                 kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return true;
}

NS_ASSUME_NONNULL_END
