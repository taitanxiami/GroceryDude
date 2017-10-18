//
//  Item+CoreDataProperties.h
//  GroceryDude
//
//  Created by dianda on 2017/10/18.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nonatomic) BOOL collected;
@property (nonatomic) BOOL listed;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSData *photoData;
@property (nonatomic) float quantity;
@property (nullable, nonatomic, retain) NSSet<LocationAtHome *> *locationAtHome;
@property (nullable, nonatomic, retain) NSSet<LocationAtShop *> *locationAtShop;
@property (nullable, nonatomic, retain) Unit *unit;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addLocationAtHomeObject:(LocationAtHome *)value;
- (void)removeLocationAtHomeObject:(LocationAtHome *)value;
- (void)addLocationAtHome:(NSSet<LocationAtHome *> *)values;
- (void)removeLocationAtHome:(NSSet<LocationAtHome *> *)values;

- (void)addLocationAtShopObject:(LocationAtShop *)value;
- (void)removeLocationAtShopObject:(LocationAtShop *)value;
- (void)addLocationAtShop:(NSSet<LocationAtShop *> *)values;
- (void)removeLocationAtShop:(NSSet<LocationAtShop *> *)values;

@end

NS_ASSUME_NONNULL_END
