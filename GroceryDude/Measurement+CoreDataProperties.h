//
//  Measurement+CoreDataProperties.h
//  GroceryDude
//
//  Created by dianda on 2017/10/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
//

#import "Measurement+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Measurement (CoreDataProperties)

+ (NSFetchRequest<Measurement *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *abc;

@end

NS_ASSUME_NONNULL_END
