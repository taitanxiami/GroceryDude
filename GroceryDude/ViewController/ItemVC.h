//
//  ItemVC.h
//  GroceryDude
//
//  Created by dianda on 2017/10/28.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Item+CoreDataProperties.h"
@interface ItemVC : UIViewController

@property (strong, nonatomic) NSManagedObjectID *selectObjectId;

@end
