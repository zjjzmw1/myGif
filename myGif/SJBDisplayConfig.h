//
//  SJBDisplayConfig.h
//  shijiebang
//
//  Created by 殷 on 14-3-11.
//  Copyright (c) 2014年 ShiJieBang. All rights reserved.
//
#if DEBUG
#define SJBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SJBLog(tmt, ...)
#endif
#ifndef SCREENBOUND
#define SCREENBOUND [UIScreen mainScreen].bounds
#endif

#ifndef APPBOUND
#define APPBOUND [UIScreen mainScreen].applicationFrame
#endif

#define kImageWidth 104.0f
#define kImageSpacing 2.0f


#define kPreferedFontType                   @"HiraginoSansGB-W3"
#define kPreferedFontBoldType               @"HiraginoSansGB-W6"
#define kDefaultFontType                    @"HelveticaNeue-Light"
#define kDefaultFontBoldType                @"HelveticaNeue-Bold"
#define kDigitFontType                      @"HelveticaNeue-Thin"
#define kDigitFontBoldType                  @"HelveticaNeue"
#define kContextFontKerning                 1.0f

#define kAnimationDuration                  0.25f

#define kNavigationBarColor                 @"#5187FB"
#define kNavigationBarHeight                64.0f
#define kNavigationBarTitleFontSize         20.0f
#define kNavigationItemSpacerWidth          -15.0f
#define kNavigationTextItemSpacerWidth      0.0f
#define kNavigationItemFontColor            @"#727171"
#define kNavigationItemFontColorSelected    @"#FF8A00"
#define kNavigationItemFontColorHighlighted @"#FF8A00"
#define kNavBtnRect                         CGRectMake(0.0f, 0.0f, 44.0f, 43.0f)

#define kTabbarHeight                       49.0f
#define kDefaultTabFontSize                 10.0f
#define kMainTopSectionBarHeight            100.0f

#define kTripCellHeight                     220.0f
#define kTripTopAreaHeight                  140.0f

#define kQuestionCellHeight                 20.0f
#define kAccountCellHeight                  47.0f

#define kAccountTextFieldTextColor          @"#727171"
#define kAccountTextFieldHintTextColor      @"#E75C5C"

#define kMainAdWidth                        SCREENBOUND.size.width
#define kMainAdHeight                       150.0f
#define kMainAdsBarWdith                    145.0f
#define kMainAdsBarHeight                   60.0f
#define kMainAdsBarVerticalMargin           10.0f
#define kSectionItemTitleTop                70.0f

#define kMainCellDefaultHeight              320.0f

#define kBlogCellHeight                     150.0f

#define kMainCellIdentifier                 @"MainCell"
#define kPromotedAppCellIdentifier          @"PromotedAppCell"
#define kSettingCellIdentifier              @"SettingCell"
#define kBlogCellIdentifier                 @"BlogCell"
#define kQuestionCellIdentifier             @"QuestionCell"

#define ItemWidth 14
#define ItemHeight 20

#define ItemWidth_right 21
#define ItemHeight_right 21

#define ItemWidth_right_share 16
#define ItemHeight_right_share 21

#define kMyTextFieldWidth 5
#define kMyTextFieldHeight 30
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#pragma mark ===============常用的宏定义================

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kStateBarHeight 0
#define kMainHeight (ScreenHeight - StateBarHeight)
#define kMainWidth ScreenWidth
#define kIsIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define BACKGROUND_CORLOR  kRgbColor(244, 244, 244)
#define CLEARCOLOR [UIColor clearColor]
#define kUserDefault [NSUserDefaults standardUserDefaults]
#define kApplication [UIApplication sharedApplication]
#define kDataEnv [DataEnvironment sharedDataEnvironment]
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)
#define kRgbColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define kRgbColor2(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define k_nav_bgColor kRgbColor2(47, 48, 62, 1)

/* 根据名称加载有缓存图片 */
#define kImageNamed(name) [UIImage imageNamed:name]

#define kCurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

#pragma mark ===============不常用的宏定义================

#define kSystemError @"系统繁忙，请稍后再试！"
/* 获取系统目录 */
#define kGetDirectory(NSSearchPathDirectory) [NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory, NSUserDomainMask, YES)lastObject]
/* 获取NSFILEMANAGER对象 */
#define kFileManager [NSFileManager defaultManager]
/* 获取程序代理 */
#define kAppdelegate        ((AppDelegate *)[[UIApplication sharedApplication] delegate])
/* 获取任意WINDOW对象 */
#define kWindow             [[[UIApplication sharedApplication] windows] lastObject]
/* 获取KEYWINDOW对象 */
#define kKeyWindow          [[UIApplication sharedApplication] keyWindow]
/* 获取USERDEFAULTS对象 */
#define kNotificactionCenter [NSNotificationCenter defaultCenter]
/* 获取当前控制器的navigationBar */
#define kNavigationBar      [[self navigationController] navigationBar]
/* 简单提示框 */
#define kAlert(title, msg)  [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show]
/*------------------------------------加载图片---------------------------------------*/

/* 根据名称加载无缓存图片 */
#define kNoCacheImagewithName(name, ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]
/* 根据路径加载无缓存图片 */
#define kNoCacheImagewithPath(path) [UIImage imageWithContentsOfFile:path]

/*------------------------------------视图------------------------------------------*/
/* 根据TAG获取视图 */
#define kViewWithTag(PARENTVIEW, TAG, CLASS) ((CLASS *)[PARENTVIEW viewWithTag:TAG])
/* 加载NIB文件 */
#define kLOADNIBWITHNAME(CLASS, OWNER) [[[NSBundle mainBundle] loadNibNamed:CLASS owner:OWNER options:nil] lastObject]
/* 异步 */
#define kGCDAsync(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
/* 同步 */
#define kGCDMain(block) dispatch_async(dispatch_get_main_queue(),block)
/*-----------------------------------界面尺寸--------------------------------------*/
/* 导航栏高度 */
/* 工具栏高度 */
/* 是否IPad */
#define kIsIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/* 是否IPhone */
#define kIsIphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/* 获取系统信息 */
#define kSystemVersion   [[UIDevice currentDevice] systemVersion]
/* 获取当前语言环境 */
#define kCurrentLanguage [[NSLocale preferredLanguages] objectAtIndex:0]
/* 获取当前APP版本 */
#define kAppVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]



#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO

/**
 * 默认设置
 */


#define StatusBarStyle UIStatusBarStyleLightContent

#define StateBarHeight ((IS_IOS_7)?0:0)

#define NavBarHeight ((IS_IOS_7)?65:45)

#define BottomHeight ((IS_IOS_7)?49:0)

#define ScreenHeight ((IS_IOS_7)?([UIScreen mainScreen].bounds.size.height):([UIScreen mainScreen].bounds.size.height - 20))

#define ConentViewWidth  [UIScreen mainScreen].bounds.size.width

#define ConentViewHeight ((IS_IOS_7)?([UIScreen mainScreen].bounds.size.height - NavBarHeight):([UIScreen mainScreen].bounds.size.height - NavBarHeight -20))

#define ConentViewFrame CGRectMake(0,NavBarHeight,ConentViewWidth,ConentViewHeight)

#define MaskViewDefaultFrame CGRectMake(0,NavBarHeight,ConentViewWidth,ConentViewHeight)

#define MaskViewFullFrame CGRectMake(0,0,ConentViewWidth,[UIScreen mainScreen].bounds.size.height-20)



