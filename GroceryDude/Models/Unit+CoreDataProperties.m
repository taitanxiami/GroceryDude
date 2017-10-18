//
//  Unit+CoreDataProperties.m
//  GroceryDude
//
//  Created by dianda on 2017/10/18.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Unit+CoreDataProperties.h"

@implementation Unit (CoreDataProperties)

+ (NSFetchRequest<Unit *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Unit"];
}

@dynamic name;
@dynamic items;

@end
