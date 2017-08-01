//
//  CVPixelBufferRef+SDLUtil.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 3/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "CVPixelBufferRef+SDLUtil.h"

NS_ASSUME_NONNULL_BEGIN

UIFont * _Nullable sdl_findFontSizeToFitText(CGSize size, NSString *text) {
    CGFloat fontSize = 100;
    
    do {
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]}
                                             context:nil].size;
        
        if (textSize.height <= size.height) {
            break;
        }
        
        fontSize -= 10.0;
    } while (fontSize > 0.0);

    return (fontSize > 0) ? [UIFont boldSystemFontOfSize:fontSize] : nil;
}

UIImage * _Nullable sdl_createTextImage(NSString *text, CGSize size) {
    UIFont *font = sdl_findFontSizeToFitText(size, text);
    
    if (!font) {
        NSLog(@"Text cannot fit inside frame");
        return nil;
    }

    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, frame);
    CGContextSaveGState(context);
    
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* textAttributes = @{
                                     NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSParagraphStyleAttributeName: textStyle
                                     };
    CGRect textFrame = [text boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:textAttributes
                                          context:nil];
    
    CGRect textInset = CGRectMake(0,
                                  (frame.size.height - CGRectGetHeight(textFrame)) / 2.0,
                                  frame.size.width,
                                  frame.size.height);
    
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
        NSLog(@"Could not create text image.");
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
