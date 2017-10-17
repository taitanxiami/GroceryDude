//
//  Measurement+CoreDataProperties.m
//  GroceryDude
//
//  Created by dianda on 2017/10/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Measurement+CoreDataProperties.h"

@implementation Measurement (CoreDataProperties)

+ (NSFetchRequest<Measurement *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Measurement"];
}

@dynamic abc;

@end
