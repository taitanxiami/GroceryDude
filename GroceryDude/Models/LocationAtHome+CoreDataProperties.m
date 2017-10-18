//
//  LocationAtHome+CoreDataProperties.m
//  GroceryDude
//
//  Created by dianda on 2017/10/18.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "LocationAtHome+CoreDataProperties.h"

@implementation LocationAtHome (CoreDataProperties)

+ (NSFetchRequest<LocationAtHome *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LocationAtHome"];
}

@dynamic storedIn;
@dynamic items;

@end
