//
//  LocalImageViewController.h
//  myGif
//
//  Created by Buddy on 21/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGImagePickerController.h"
#import "AGIPCToolbarItem.h"
#import "GifView.h"
@interface LocalImageViewController : UICollectionViewController
{
    int isBackFlag;
    AGImagePickerController *ipc;
}
@property (nonatomic ,strong) NSMutableArray *resultArray;
@end
