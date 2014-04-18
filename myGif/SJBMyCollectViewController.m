//
//  SJBMyCollectViewController.m
//  Subway
//
//  Created by Buddy on 14/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//
NSString *const MJCollectionViewCellIdentifier = @"Cell";
#import "SJBMyCollectViewController.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#define kImageWidth 104.0f
#define kImageSpacing 2.0f
@interface SJBMyCollectViewController ()

@end

@implementation SJBMyCollectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kImageWidth, kImageWidth);
        layout.sectionInset = UIEdgeInsetsMake(kImageSpacing, kImageSpacing, kImageSpacing, kImageSpacing);
        layout.minimumInteritemSpacing = kImageSpacing;
        layout.minimumLineSpacing = kImageSpacing;
        return [self initWithCollectionViewLayout:layout];
    }
    return self;
}
- (void)onlineConfigCallBack:(NSNotification *)notification {
    [kUserDefault setObject:[[MobClick getConfigParams:@"gifList"]JSONValue] forKey:@"gifList"];
    [kUserDefault synchronize];
    self.resultArray = [NSMutableArray arrayWithArray:[kUserDefault objectForKey:@"gifList"]];
    [self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UMOnlineConfigDidFinishedNotification object:nil];
}
-(void)baseNaviAction{
    Navbar *bar = (Navbar *)self.navigationController.navigationBar;
    //关键是这几句。。。。。
    [bar setTranslucent:NO];
        ///用上面的两句话也挺好，但是会用下面的一条黑线。。。。。
        if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBackground"] forBarMetrics:UIBarMetricsDefault];
        }
    
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
        
    {
        [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
    }
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    self.view.backgroundColor = BACKGROUND_CORLOR;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    [self baseNaviAction];
    [self.navigationItem setNewTitle:@"动态相册"];
    // 1.注册
    self.collectionView.backgroundColor = BACKGROUND_CORLOR;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-20);
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MJCollectionViewCellIdentifier];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([kUserDefault objectForKey:@"gifList"]!=nil) {
        self.resultArray = [NSMutableArray arrayWithArray:[kUserDefault objectForKey:@"gifList"]];
    }else{
        self.resultArray = [NSMutableArray arrayWithObjects:@"http://0d58aa18bdd2f2c4.qusu.org/upfile/2009pasdfasdfic2009s305985-ts/2014-4/www.asqql.com_2014421749050.gif?qsv=14&web_real_domain=www.asqql.com",@"http://gaoxiaotu.cn/uploads/allimg/140414/1-140414213045.gif",@"http://www.30nan.com/uploads/userup/2/140109140647-35b-0.gif", nil];
    }
}
#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MJCollectionViewCellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kImageWidth, kImageWidth)];
    imageView.image = [UIImage imageNamed:@"Icon"];
    // 下载图片
    [imageView setImageURLStr:[self.resultArray objectAtIndex:indexPath.row] placeholder:imageView.image];
    
    // 事件监听
    imageView.tag = indexPath.row;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    
    // 内容模式
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [cell addSubview:imageView];
    
    return cell;
}
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    self.collectionView.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight-64);
    int count = (int)self.resultArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
//        NSString *url = [self.resultArray[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.resultArray[i]]; // 图片路径
        photo.srcImageView = (UIImageView *)tap.view;
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SJBLog(@"第%ld据",(long)indexPath.row);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    SJBLog(@"内存警告。。。。。");
    [self.collectionView reloadData];
}

#pragma mark === 暂时不用清除缓存=====
-(void)myClearCacheAction{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}


-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
}

@end
