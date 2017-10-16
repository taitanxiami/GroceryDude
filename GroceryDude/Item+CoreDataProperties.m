//
//  Item+CoreDataProperties.m
//  GroceryDude
//
//  Created by taitanxiami on 2017/10/15.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item"];
}

@dynamic name;
@dynamic quantity;
@dynamic photoData;
@dynamic listed;
@dynamic collected;

@end
