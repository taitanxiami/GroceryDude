//
//  Item+CoreDataProperties.m
//  GroceryDude
//
//  Created by dianda on 2017/10/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item"];
}

@dynamic collected;
@dynamic listed;
@dynamic name;
@dynamic photoData;
@dynamic quantity;
@dynamic locationAtHome;
@dynamic locationAtShop;
@dynamic unit;

@end
