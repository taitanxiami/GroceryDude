//
//  PrepareTVC.h
//  GroceryDude
//
//  Created by dianda on 2017/10/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "CoreDataTVC.h"
#import "Item+CoreDataProperties.h"
#import "Unit+CoreDataProperties.h"
@interface PrepareTVC : CoreDataTVC <UIActionSheetDelegate>

@property (nonatomic, strong) UIAlertController *clearConfirmActionSheet;

@end
