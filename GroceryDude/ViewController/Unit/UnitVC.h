//
//  UnitVC.h
//  GroceryDude
//
//  Created by dianda on 2017/10/29.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "Unit+CoreDataProperties.h"
@interface UnitVC : UIViewController


// 数据唯一ID
@property (strong, nonatomic) NSManagedObjectID *selectedID;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
