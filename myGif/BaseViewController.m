//
//  BaseViewController.m
//  CustomNavBarTest
//
//  Created by apple on 13-12-19.
//  Copyright (c) 2013年 YingYing. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

#import "UIImage+GIF.h"

@interface BaseViewController ()
{
    BOOL _tabbarStatus;
}
@end

@implementation BaseViewController
@synthesize myBaseDict,applications;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.myBaseDict = [[NSMutableDictionary alloc]initWithCapacity:20];
        self.applications = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return self;
}

-(void)qingqiu{

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationItem setNewTitle:@"日报"];
//    [self.navigationItem setBackItemWithTarget:self action:@selector(back) title:nil];
//    [self.navigationItem setRightItemWithTarget:self action:@selector(rightAction:) title:@"编辑"];
    
//    ///自带的导航栏
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:kImageNamed(@"DT_back") style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    self.view.backgroundColor = BACKGROUND_CORLOR;
}

-(UIBarButtonItem *)rightButton:(NSString *)tempString{
    UIButton *tempRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempRight setImage:kImageNamed(tempString) forState:UIControlStateNormal];
    tempRight.frame = CGRectMake(0,0, 21, 21);
    [tempRight addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:tempRight];
    return rightBtn;
   
}
-(UILabel *)titleLabel:(NSString *)tempString{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = tempString;
    return titleLabel;
}
-(UIBarButtonItem *)leftButton:(NSString *)tempString{
    UIButton *tempLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempLeft setImage:kImageNamed(tempString) forState:UIControlStateNormal];
    tempLeft.frame = CGRectMake(0,0, 15, 21);
    [tempLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:tempLeft];
    return leftBtn;
    
}
-(void)rightAction:(id)sender{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Navbar *bar = (Navbar *)self.navigationController.navigationBar;
    
    //关键是这几句。。。。。
    [bar setTranslucent:NO];
    if (IS_IOS_7) {
        
//        [bar setTintColor:k_nav_bgColor];
//        [bar setBarTintColor:k_nav_bgColor];
        ///用上面的两句话也挺好，但是会用下面的一条黑线。。。。。
        if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"DT_navi_64.png"] forBarMetrics:UIBarMetricsDefault];
        }
    }else{
        [bar setBackgroundImage:kImageNamed(@"DT_navi.png") forBarMetrics:UIBarMetricsDefault];
        [bar.layer setMasksToBounds:YES];

    }
//            [self followScrollView:self.view];  //是否隐藏导航栏用的 。这个目前不能用，里面有代码

    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
        
    {
        [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
}


- (void)back
{

        [self.navigationController popViewControllerAnimated:YES];

}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
