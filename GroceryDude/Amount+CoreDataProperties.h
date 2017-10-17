//
//  Amount+CoreDataProperties.h
//  GroceryDude
//
//  Created by dianda on 2017/10/17.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Amount+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Amount (CoreDataProperties)

+ (NSFetchRequest<Amount *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *xyz;

@end

NS_ASSUME_NONNULL_END
