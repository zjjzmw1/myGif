//
//  ViewControllerFactory.m
//  windows
//
//  Created by lijunlong on 13-3-1.
//  Copyright (c) 2013年 lijunlong. All rights reserved.
//

#import "ViewControllerFactory.h"

@implementation ViewControllerFactory
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    
    return img;
}
+ (void)removeSubviews: (UIView *)superview{
    for( UIView* view in superview.subviews ){
        [view removeFromSuperview];
    }
}
+(void)creatRequest:(NSString *)urlString paramDict:(NSMutableDictionary *)paramDict delegate:(id)delegate{
    //    NSLog(@"paramDict====%@",paramDict);
//    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    if (! [delegate isKindOfClass:[UIView class]]) {
//        BaseViewController *baseVc = (BaseViewController*)delegate;
//        baseVc.formDataRequest = requestForm;
//    }
//    
//    for (id key in [paramDict keyEnumerator])
//    {
//        //        NSLog(@"===++===%@",[paramDict objectForKey:key]);
//        [requestForm setPostValue:[paramDict objectForKey:key] forKey:key];
//    }
//    [requestForm setDelegate:delegate];
//    [requestForm startAsynchronous];

}

#pragma mark ====== 拨打电话的方法 ======
+(void)telViewController:(id)viewController telNum:(NSString *)telNum{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:(id)[ViewControllerFactory sharedManager] cancelButtonTitle:@"取消" destructiveButtonTitle:telNum otherButtonTitles:nil, nil];
//    UIViewController *tempViewController = (id)viewController;
//    [actionSheet showInView:tempViewController.view];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}
#pragma mark ====== 是否取消或者继续拨打电话 ======
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *telString = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex==0) {
        NSString *deviceType = [UIDevice currentDevice].model;
        if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不能打电话" delegate:nil cancelButtonTitle:@"好的,知道了" otherButtonTitles:nil,nil];
            [alert show];
            return;
        }
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telString]];// 貌似tel:// 或者 tel: 都行
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [[actionSheet superview] addSubview:callWebview];
    }
}

#pragma mark ====== 弹出是否登陆的的提示框 ======
+(void)showLoginAlert:(id)ViewController{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"先登录" message:@"您需要先登录才能完成操作" delegate:ViewController cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
    [alert show];
}
#pragma mark ====== 弹出ptstr过期的提示框 ======
+(void)showOutOfDateAlert:(id)ViewController{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的登陆信息已过期" message:@"是否从新登陆" delegate:ViewController cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
    [alert show];

}

+(void)showMessageAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark ====== 请求失败的情况，比如：返回10002等等 ======
+(void)requestFailCode:(NSString *)code ViewController:(id)ViewController resDict:(NSDictionary *)resDict{
    if ([code isEqualToString: @"10002"]){
        [ViewControllerFactory showOutOfDateAlert:ViewController];
    }else{
        NSLog(@"错误信息==%@",[resDict objectForKey:@"msg"]);
    }
    
}

+(BOOL)saveFileToLoc:(NSString *) fileName theFile:(id) file{
//    SJBLog(@"%@",file);
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *urlString2 = @"http://i.meijika.com/business/home.txt";
    NSString *CachePath = [fileName stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
    NSString *filename=[Path stringByAppendingPathComponent:CachePath];
//    SJBLog(@"%@",fileName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filename]) {
        if (! [fileManager createFileAtPath:filename contents:nil attributes:nil]) {
            SJBLog(@"createFile error occurred");
        }
    }
   return  [file writeToFile:filename atomically:YES];
}

+(BOOL) getFileFromLoc:(NSString*)filePath into:(id)file {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *CachePath = [filePath stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
    NSString *filename=[Path stringByAppendingPathComponent:CachePath];
    
    if ([file isKindOfClass:[NSMutableDictionary class]]) {
         [file setDictionary: [NSMutableDictionary dictionaryWithContentsOfFile:filename]];
    }else if ([file isKindOfClass:[NSMutableArray class]]) {
         [file addObjectsFromArray: [NSMutableArray arrayWithContentsOfFile:filename]];
    }
    if ([file count]==0) {
        return NO;
    }
    return YES;
}



+ (NSString *)md5Digest:(NSString *)str
{
//    const char *cStr = [str UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, strlen(cStr), result);
//    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5],result[6], result[7],result[8], result[9], result[10], result[11], result[12],
//             result[13], result[14],result[15]] uppercaseString];
    return @"aaa";
}

static ViewControllerFactory *classA = nil;//静态的该类的实例
+ (ViewControllerFactory *)sharedManager
{
@synchronized(self) {
    if (!classA) {
        classA = [[super allocWithZone:NULL]init];
    }
    return classA;
}
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


#pragma mark ========从时间戳转换为时间==========
+(NSString *)fromTimeChuoTotime:(NSString *)timeChuo{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *nowDate = [NSDate date];
    NSDate *yesterDate = [NSDate dateWithTimeInterval:-24*3600 sinceDate:nowDate];
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[timeChuo doubleValue]];
    
    NSString *nowDateString = [formatter stringFromDate:nowDate];
    NSString *yesterDateString = [formatter stringFromDate:yesterDate];
    NSString *myDateString = [formatter stringFromDate:myDate];
    
    if ([myDateString isEqualToString:nowDateString]) {
        return @"今天";
    }else if([myDateString isEqualToString:yesterDateString]){
        return @"昨天";
    }else{
        return myDateString;
    }

}
#pragma mark ========从时间戳转换为时间==========
+(NSString *)fromTimeChuoTotime2:(NSString *)timeChuo{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];

    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[timeChuo doubleValue]];
    
    NSString *myDateString = [formatter stringFromDate:myDate];
    
    
        return myDateString;

    
}
+(NSDate *)fromStringToDate:(NSString *)sender{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:@"hh:mm"];
    NSDate* inputDate = [inputFormatter dateFromString:sender];
    return inputDate;
}
+(NSString *)fromTimeToChui:(NSDate *)date
{
    //把获取的时间转化为当前时间
//    NSDate *date = [NSDate date];//现在时间,你可以输出来看下是什么格式
    //    NSLog(@"%@", datenow);
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; //时区
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //    NSLog(@"%@", localeDate);
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    SJBLog(@"timeSp:%@",timeSp); //时间戳的值
    
    return timeSp;
}

+(NSString *)fromNowDateToString{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *nowDateString = [formatter stringFromDate:nowDate];
   
    return nowDateString;
}


+(CGSize)labelHuanHang:(UILabel *)tempLabel{
    CGSize tempSize = [tempLabel.text sizeWithFont:[UIFont fontWithName:@"Arial" size:13] constrainedToSize:CGSizeMake(tempLabel.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tempLabel.numberOfLines = 0;
    [tempLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    tempLabel.frame = CGRectMake(tempLabel.frame.origin.x, tempLabel.frame.origin.y, tempSize.width, tempSize.height);
    return tempSize;
}
char tohex(int n)
{
    
    if(n>=10 && n<=15)
    {
    	return 'A'+n-10;
    }
    return '0'+n;
}
void dec2hex(int n,char *buf)
{
	int i=0;
	int mod;
	while(n)
	{
		mod = n%16;
		buf[i++]=tohex(mod);
		n=n/16;
	}
    //得进行反序。
	int j,k;
	for(j=0,k=i-1;j<i/2;j++,k--)
	{
		char temp;
		temp = buf[j];
		buf[j] = buf[k];
		buf[k] = temp;
	}
	buf[i]='\0';
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString {  //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    SJBLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}

//普通字符串转换为十六进制的。

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
+(NSString *)quKongGe:(NSString *)sender{
    ///去除两端空格
    ///sender 是输入框里面的text。
    NSString *temp = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return temp;
    
}
+(NSString *)quKongGeALL:(NSString *)sender{
    ///去所有的空格。
    ///sender 是输入框里面的text。
   NSString *strUrl = [sender stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return strUrl;
    
}
+(NSString *)quKongGeAndEnder:(NSString *)sender{
   /// 去除两端空格和回车
    
    NSString *text = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    return  text;
}

+(UIImage *)yasuoCameraImage:(UIImage *)image{
    int size = 50480;///50k
    int current_size = 0;
    int actual_size = 0;
    NSData *imgData1 = UIImageJPEGRepresentation(image, 1.0);
    current_size = [imgData1 length];
    if (current_size > size) {
        actual_size = size/current_size;
        imgData1 = UIImageJPEGRepresentation(image, actual_size);
    }
    UIImage *theImage = [UIImage imageWithData:imgData1];
    return theImage; //返回压缩后的图片
}
//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
//单个文件的大小
+ (float) fileSizeAtPath:(NSString*) filePath{
    
    //
    //    NSData* data = [NSData dataWithContentsOfFile:[VoiceRecorderBaseVC getPathByFileName:_convertAmr ofType:@"amr"]];
    //    NSLog(@"amrlength = %d",data.length);
    //    NSString * amr = [NSString stringWithFormat:@"amrlength = %d",data.length];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
}
///是否含有中文。。。。
+(int)hasZhongWen:(NSString *)tempString{
    int length = [tempString length];
    
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [tempString substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return 1;
        }
    }
    return 0;
}





@end
