//
//  LocationAtShop+CoreDataProperties.m
//  GroceryDude
//
//  Created by dianda on 2017/10/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "LocationAtShop+CoreDataProperties.h"

@implementation LocationAtShop (CoreDataProperties)

+ (NSFetchRequest<LocationAtShop *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LocationAtShop"];
}

@dynamic aisle;
@dynamic items;

@end
