//
//  AGViewController.m
//  AGImagePickerController Demo
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//"ALAsset - Type:Photo, URLs:assets-library://asset/asset.PNG?id=84A96083-2A40-4C6C-AA25-43559FD05F94&ext=PNG"

#import "AGViewController.h"

#import "AGIPCToolbarItem.h"

@interface AGViewController ()
{
    AGImagePickerController *ipc;
}

@end

@implementation AGViewController

#pragma mark - Properties

@synthesize selectedPhotos;

#pragma mark - Object Lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.selectedPhotos = [NSMutableArray array];
        
        __block AGViewController *blockSelf = self;
        
        ipc = [[AGImagePickerController alloc] initWithDelegate:nil];
        ipc.didFailBlock = ^(NSError *error) {
            NSLog(@"Fail. Error: %@", error);
            
            if (error == nil) {
                [blockSelf.selectedPhotos removeAllObjects];
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
            [blockSelf.selectedPhotos setArray:info];
            SJBLog(@"=====%@",blockSelf.selectedPhotos);
            NSLog(@"Info: %@", info);
           
            
           [blockSelf dismissViewControllerAnimated:YES completion:nil];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        };
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImageView *tempImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
    if (self.selectedPhotos.count > 0) {
        tempImageV.image = [ViewControllerFactory fullResolutionImageFromALAsset:[self.selectedPhotos objectAtIndex:0]];
    }
    
    
    [self.view addSubview:tempImageV];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Public methods

- (void)openAction:(id)sender
{    
    // Show saved photos on top
    ipc.shouldShowSavedPhotosOnTop = NO;
    ipc.shouldChangeStatusBarStyle = YES;
    ipc.selection = self.selectedPhotos;
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



@end
