//
//  YouVC.h
//  SCFavorites
//
//  Created by Prakash Donga on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesVC.h"

@interface YouVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *tableview;
    NSArray *dataArray;
}

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSArray *dataArray;

@end
