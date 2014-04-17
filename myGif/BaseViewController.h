//
//  BaseViewController.h
//  CustomNavBarTest
//
//  Created by apple on 13-12-19.
//  Copyright (c) 2013年 YingYing. All rights reserved.
//

#import "Navbar.h"      //自定义导航栏。

@interface BaseViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *myBaseDict;  ///请求url的时候传入的参数。。
@property (strong, nonatomic) NSMutableArray *applications;     ///返回的model的上一层。。

- (void)back;
//下拉菜单用的：
///自定义导航栏用的。。。。
-(UIBarButtonItem *)rightButton:(NSString *)tempString;
-(UILabel *)titleLabel:(NSString *)tempString;
-(UIBarButtonItem *)leftButton:(NSString *)tempString;
@end
