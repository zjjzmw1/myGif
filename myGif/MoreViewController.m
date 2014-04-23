//
//  MoreViewController.m
//  myGif
//
//  Created by Buddy on 21/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "MoreViewController.h"
#import "LocalImageViewController.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setNewTitle:@"更多"];
     [self.navigationItem setBackItemWithTarget:self action:@selector(back) title:nil];
}
- (IBAction)localImage:(id)sender {
    LocalImageViewController *detailVC = [[LocalImageViewController alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
