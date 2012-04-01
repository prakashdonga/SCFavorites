//
//  UIImage+SCFavorites.m
//  SCFavorites
//
//  Created by Prakash Donga on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+SCFavorites.h"

@implementation UIImage (SCFavorites)

- (UIImage *)imageCropTo:(CGSize)newSize forRetinaDisplay:(BOOL)forRetinaDisplay
{
    if (forRetinaDisplay && [[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        if ([[UIScreen mainScreen] scale] == 2.0) 
        {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } 
        else 
        {
            UIGraphicsBeginImageContext(newSize);
        }
    } 
    else 
    {
        UIGraphicsBeginImageContext(newSize);
    }
    
    [self drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
	UIImage* cropImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return cropImage;
}

@end
