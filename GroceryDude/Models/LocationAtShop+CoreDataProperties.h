//
//  LocationAtShop+CoreDataProperties.h
//  GroceryDude
//
//  Created by dianda on 2017/10/18.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "LocationAtShop+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LocationAtShop (CoreDataProperties)

+ (NSFetchRequest<LocationAtShop *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *aisle;
@property (nullable, nonatomic, retain) NSSet<Item *> *items;

@end

@interface LocationAtShop (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet<Item *> *)values;
- (void)removeItems:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
