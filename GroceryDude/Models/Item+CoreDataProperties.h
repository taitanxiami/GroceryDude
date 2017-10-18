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

//是否拿到了所在购买的商品，购物清单中可以勾掉
@property (nonatomic) BOOL collected;
//是否出现在购物清单中
@property (nonatomic) BOOL listed;
@property (nullable, nonatomic, copy) NSString *name;
//图片
@property (nullable, nonatomic, retain) NSData *photoData;
//数量
@property (nonatomic) float quantity;

//计量单位
@property (nullable, nonatomic, retain) Unit *unit;
@end

NS_ASSUME_NONNULL_END
