//
//  Item+CoreDataClass.h
//  GroceryDude
//
//  Created by dianda on 2017/10/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationAtHome, LocationAtShop, Unit;

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
