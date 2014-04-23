//
//  ViewControllerFactory.h
//  windows
//
//  Created by lijunlong on 13-3-1.
//  Copyright (c) 2013年 lijunlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewControllerFactory : NSObject

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
//本来是网络的。
+(void)creatRequest:(NSString *)urlString paramDict:(NSMutableDictionary *)paramDict delegate:(id)delegate;


//拨打电话.
+(void)telViewController:(id)viewController telNum:(NSString *)telNum;
//拨打电话时候用的单例。
+ (ViewControllerFactory *)sharedManager;

+(BOOL)saveFileToLoc:(NSString *) fileName theFile:(id) file;
+(BOOL) getFileFromLoc:(NSString*)filePath into:(id)dic;



+ (NSString *)md5Digest:(NSString *)str;
//把时间戳转换为时间。
+(NSString *)fromTimeChuoTotime:(NSString *)timeChuo;
+(NSString *)fromTimeChuoTotime2:(NSString *)timeChuo;
+(NSString *)fromTimeToChui:(NSDate *)date;
+(NSDate *)fromStringToDate:(NSString *)sender;
//下面两个是提示是否登陆，和登陆信息已经过期了的提示框。
+(void)showLoginAlert:(id)ViewController;
+(void)showOutOfDateAlert:(id)ViewController;
+(void)showMessageAlert:(NSString *)message;
//下面是请求失败的方法。
+(void)requestFailCode:(NSString *)code ViewController:(id)ViewController resDict:(NSDictionary *)resDict;
+ (NSString *)stringFromHexString:(NSString *)hexString;
+ (NSString *)hexStringFromString:(NSString *)string;
+(NSString *)fromNowDateToString;

+(CGSize)labelHuanHang:(UILabel *)tempLabel;

+(NSString *)quKongGe:(id)sender;
+(NSString *)quKongGeALL:(NSString *)sender;
+(NSString *)quKongGeAndEnder:(id)sender;
+(UIImage *)yasuoCameraImage:(UIImage *)image;

+ (float ) folderSizeAtPath:(NSString*) folderPath;
+ (float) fileSizeAtPath:(NSString*) filePath;
///是否含有中文。。。。
+(int)hasZhongWen:(NSString *)tempString;

@end
