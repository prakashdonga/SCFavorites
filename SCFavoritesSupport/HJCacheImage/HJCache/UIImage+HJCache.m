//
//  UIImage+SCFavorites.m
//  SCFavorites
//
//  Created by Prakash Donga on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+HJCache.h"

@implementation UIImage (SCFavorites)

//Inspired by http://stackoverflow.com/questions/158914/cropping-a-uiimage
- (UIImage *)crop:(CGRect)rect {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
         if ([[UIScreen mainScreen] scale] == 2.0) {
             rect = CGRectMake(rect.origin.x * 2.0,
                               rect.origin.y * 2.0,
                               rect.size.width * 2.0,
                               rect.size.height * 2.0);
         }
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


- (UIImage *)imageByResizingTo:(CGSize)newSize forRetinaDisplay:(BOOL)forRetinaDisplay
{
    if (forRetinaDisplay && [[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    [self drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

@end
