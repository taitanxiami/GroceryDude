//
//  Amount+CoreDataProperties.m
//  GroceryDude
//
//  Created by dianda on 2017/10/17.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Amount+CoreDataProperties.h"

@implementation Amount (CoreDataProperties)

+ (NSFetchRequest<Amount *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Amount"];
}

@dynamic xyz;

@end
