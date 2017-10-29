//
//  LocationAtShopVC.h
//  GroceryDude
//
//  Created by dianda on 2017/10/29.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "LocationAtShop+CoreDataProperties.h"
@interface LocationAtShopVC : UIViewController
@property (strong, nonatomic) NSManagedObjectID *selectedID;
@end
