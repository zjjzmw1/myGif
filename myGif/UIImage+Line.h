//
//  UIImage+Line.h
//  Subway
//
//  Created by Buddy on 14/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Line)
///自己添加的。。。为了去除导航栏下面的一条黑线。
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
