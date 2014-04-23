//
//  LocalImageViewController.m
//  myGif
//
//  Created by Buddy on 21/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//
NSString *const MyLocalImageCell = @"Cell";
#import "LocalImageViewController.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@interface LocalImageViewController ()

@end

@implementation LocalImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        __block LocalImageViewController *blockSelf = self;
        blockSelf.resultArray = [NSMutableArray array];
        ipc = [[AGImagePickerController alloc] initWithDelegate:nil];
        ipc.didFailBlock = ^(NSError *error) {
            NSLog(@"Fail. Error: %@", error);
            
            if (error == nil) {
                [blockSelf.resultArray removeAllObjects];
                NSLog(@"User has cancelled.");
                
                [blockSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                
                // We need to wait for the view controller to appear first.
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [blockSelf dismissViewControllerAnimated:YES completion:nil];
                });
            }
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
        };
        ipc.didFinishBlock = ^(NSArray *info) {
            [blockSelf.resultArray setArray:info];
            SJBLog(@"=====%@",blockSelf.resultArray);
            NSLog(@"Info: %@", info);
            
            
            [blockSelf dismissViewControllerAnimated:YES completion:nil];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        };

        
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kImageWidth, kImageWidth);
        layout.sectionInset = UIEdgeInsetsMake(kImageSpacing, kImageSpacing, kImageSpacing, kImageSpacing);
        layout.minimumInteritemSpacing = kImageSpacing;
        layout.minimumLineSpacing = kImageSpacing;
        return [self initWithCollectionViewLayout:layout];
    }
    return self;
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
    [self.navigationItem setNewTitle:@"本地相册"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightAction) title:@"添加"];
    
    // 1.注册
    self.collectionView.backgroundColor = BACKGROUND_CORLOR;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-20);
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MyLocalImageCell];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backReload) name:@"backReload" object:nil];
}

-(void)rightAction{
    // Show saved photos on top
    ipc.shouldShowSavedPhotosOnTop = NO;
    ipc.shouldChangeStatusBarStyle = YES;
    ipc.selection = self.resultArray;
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"+ Select All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] andSelectionBlock:nil];
    AGIPCToolbarItem *selectOdd = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"+ Select Odd" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return !(index % 2);
    }];
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"- Deselect All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];
    ipc.toolbarItemsForManagingTheSelection = @[selectAll, flexible, selectOdd, flexible, deselectAll];
    [self presentViewController:ipc animated:YES completion:nil];

    
}


-(void)backReload{
    isBackFlag = 1;
    
    [self.collectionView reloadData];
    self.collectionView.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight-64);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"本地相册"];
    SJBLog(@"self.resultArray ==== %@",self.resultArray);
    
    
    
    [self.collectionView reloadData];
}
#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyLocalImageCell forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kImageWidth, kImageWidth)];
//    imageView.image = [UIImage imageNamed:@"Icon"];
    // 下载图片
//    [imageView setImageURLStr:[self.resultArray objectAtIndex:indexPath.row] placeholder:imageView.image];
//    imageView.image = [ViewControllerFactory fullResolutionImageFromALAsset:[self.resultArray objectAtIndex:indexPath.row]];
    [imageView showGifImage:[ViewControllerFactory fullResolutionImageFromALAsset:[self.resultArray objectAtIndex:indexPath.row]]];
    SJBLog(@"===image ==== %@",[ViewControllerFactory fullResolutionImageFromALAsset:[self.resultArray objectAtIndex:indexPath.row]]);
    // 事件监听
    imageView.tag = indexPath.row;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    
    // 内容模式
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    NSData *localData = UIImageJPEGRepresentation([ViewControllerFactory fullResolutionImageFromALAsset:[self.resultArray objectAtIndex:indexPath.row]], 1.0f);
//    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"run" ofType:@"gif"]];
    
    GifView *dataView = [[GifView alloc] initWithFrame:CGRectMake(0, 0, kImageWidth, kImageWidth) data:localData];
    
//    [self.view addSubview:dataView];
    
    [cell.contentView addSubview:dataView];
    
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
        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:self.resultArray[i]]; // 图片路径
        photo.image = [ViewControllerFactory fullResolutionImageFromALAsset:[self.resultArray objectAtIndex:i]];
        
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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"本地相册"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    SJBLog(@"内存警告。。。。。");
    [self.collectionView reloadData];
}

@end

