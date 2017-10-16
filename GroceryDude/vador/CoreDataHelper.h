//
//  CoreDataHelper.h
//  GroceryDude
//
//  Created by taitanxiami on 2017/10/15.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic) NSPersistentStore *store;


- (void)setupCoreData;
- (void)saveContext;
@end
