//
//  CoreDataHelper.m
//  GroceryDude
//
//  Created by taitanxiami on 2017/10/15.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "CoreDataHelper.h"
#import <Foundation/Foundation.h>
@implementation CoreDataHelper

#define DEBGU 1
static NSString *storeFileName = @"GroceryDude.sqlite";

#pragma mark ====================  FILES ====================

#pragma mark ====================  PATHS ====================

- (NSString *)applacationDocumentDiretory {
    
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//数据都存在documents 下的Stoers 目录下
- (NSURL *)applacationStoreDirectory {
    if (DEBGU == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    NSURL *storeDirectory = [[NSURL fileURLWithPath:[self applacationDocumentDiretory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeDirectory path]]) {
        //如果目录不存在
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:[storeDirectory path] withIntermediateDirectories:YES attributes:nil error:&error]) {
            if (DEBGU == 1) {
                NSLog(@"Successfully created Stores directory");
            }
        }else {
            NSLog(@"Failed creat Stores directory %@",error);
        }
    }
    return storeDirectory;
}

//数据库路径
- (NSURL *)storeURL {
    if (DEBUG == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    return [[self applacationStoreDirectory] URLByAppendingPathComponent:storeFileName];
}

#pragma mark ====================  SETUP ====================

- (instancetype)init {
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self = [super init]) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        _coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model];
        _context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:_coordinator];
    }
    return self;
}


- (void)loadStore {
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_store) {
        return;  //如果已经加载，就不在加载
    }
    NSError *error = nil;
    _store  = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
    if (!_store) {
        NSLog(@"Failed to add store Error: %@",error);
    }else {
        NSLog(@"Successfully added store");
    }
    
}
- (void)setupCoreData {
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self loadStore];
}
#pragma mark ====================  SAVING ====================
- (void)saveContext {
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"context saved changes to persitent store");
        }else {
            NSLog(@"Failed to save context: %@", error);
        }
    }else {
        NSLog(@"Skip context save , there are no changes!");
    }
}

@end

