//
//  SJBMyCollectViewController.h
//  Subway
//
//  Created by Buddy on 14/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJBMyCollectViewController : UICollectionViewController
{
  BuddyRefreshBaseView *_refreshView;
}
@property (nonatomic ,strong) NSMutableArray *resultArray;
@end
