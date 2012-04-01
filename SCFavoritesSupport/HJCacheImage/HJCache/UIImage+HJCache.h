//
//  UIImage+SCFavorites.h
//  SCFavorites
//
//  Created by Prakash Donga on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HJCache)

- (UIImage *)crop:(CGRect)rect;
- (UIImage *)imageByResizingTo:(CGSize)newSize forRetinaDisplay:(BOOL)forRetinaDisplay;

@end
