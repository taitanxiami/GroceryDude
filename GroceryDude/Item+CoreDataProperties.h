//
//  Item+CoreDataProperties.h
//  GroceryDude
//
//  Created by taitanxiami on 2017/10/15.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float quantity;
@property (nullable, nonatomic, retain) NSData *photoData;
@property (nonatomic) BOOL listed;
@property (nonatomic) BOOL collected;

@end

NS_ASSUME_NONNULL_END
