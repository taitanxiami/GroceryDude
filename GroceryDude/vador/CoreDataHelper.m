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
        
        
        _importContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_importContext performBlockAndWait:^{
           
            [_importContext setPersistentStoreCoordinator:_coordinator];
            [_importContext setUndoManager:nil]; // 默认为nil
        }];
        
    }
    return self;
}


- (void)loadStore {
    
    
    
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_store) {
        NSLog(@"存储区已经创建，无需在创建store");
        return;  //如果已经加载，就不在加载
    }
    NSError *error = nil;
    
    
    
    BOOL useMigrationManager = NO;
    if (useMigrationManager && [self isMifrationNeccessnaryForStore:[self storeURL]]) {
//        [self performBackgroundManagerMigrationForStore:[self storeURL]];
    }else {
#warning 禁用SQLite日志模式
        NSDictionary *options = @{
                                  NSSQLitePragmasOption: @{@"journal_mode":@"DELETE"}
                                  ,NSMigratePersistentStoresAutomaticallyOption:@YES
                                  ,NSInferMappingModelAutomaticallyOption:@YES
                                  };
        
        _store  = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:[self storeURL]
                                                   options:options
                                                     error:&error];
        if (!_store) {
            NSLog(@"Failed to add store Error: %@",error);
        }else {
            NSLog(@"Successfully added store");
        }

    }
    
    
}
- (void)setupCoreData {
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self loadStore];
    [self checkIfDefaultDataNeedsImporting];
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
            
            [self showValidationError:error];
        }
    }else {
        NSLog(@"Skip context save , there are no changes!");
    }
}
#pragma mark ====================  MIGRATION MANAGER ====================
//是否需要迁移数据

- (BOOL)isMifrationNeccessnaryForStore:(NSURL *)storeUrl {
     if (DEBGU == 1) {  NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    //如果数据库文件不存在则不需要迁移数据
    if(![[NSFileManager defaultManager] fileExistsAtPath:[[self storeURL] path]]) {
        if(DEBGU == 1) { NSLog(@"SKIPPED MIGRATION : Source database missing."); }
        return NO;
    }
    
    NSError *error = nil;
    NSDictionary *sourceMetaData = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeUrl options:nil error:&error];
    
    NSManagedObjectModel *destinationModel = _coordinator.managedObjectModel;
    
    //如果source data 和 destination data 是兼容的则不需要迁移数据
    if ([destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetaData]) {
        if (DEBUG == 1) {
            NSLog(@"SKIPPED MIGATION : Source is compatiable");
            return NO;
        }
    }
    return YES;
}

//迁移数据
- (BOOL)migrationStore:(NSURL *)sourceStrore {
     if (DEBGU == 1) {  NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    BOOL suceess = NO;
    NSError *error = nil;
    
    // STEP 1 Gather the source ,destiantion and mapping model
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:sourceStrore options:nil error:&error];
    NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
    
    NSManagedObjectModel *destinationModel = _model;
    NSMappingModel *mappingModel =[NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
    
    // STEP 2 Perform migrtion ,assuming the mapping model isn't null
    
    if (mappingModel) {
        NSError *error = nil;
        NSMigrationManager *migrationManager = [[NSMigrationManager alloc]initWithSourceModel:sourceModel destinationModel:destinationModel];
        [migrationManager addObserver:self forKeyPath:@"migrationProgress" options:NSKeyValueObservingOptionNew context:NULL];
        NSURL *destinationStore = [[self applacationStoreDirectory] URLByAppendingPathComponent:@"Temp.sqlite"];
        suceess = [migrationManager migrateStoreFromURL:sourceStrore type:NSSQLiteStoreType options:nil withMappingModel:mappingModel toDestinationURL:destinationStore destinationType:NSSQLiteStoreType destinationOptions:nil error:&error];
        if (suceess) {
            
            // STEP 3 Replace the old store with the new migration store
            if ([self replaceStore:sourceStrore withStore:destinationStore]) {
                if (DEBUG == 1) {
                    NSLog(@"Successfully Migration %@ to the current model", sourceStrore.path);
                }
                [migrationManager removeObserver:self forKeyPath:@"migrationProgress"];
                
            }
        }else {
            if (DEBUG == 1) {
                NSLog(@"Failed  Migration: %@",error);
            }
        }

    }else {
        if (DEBUG == 1) {
            NSLog(@"Failed Mifration: Mapping model is null");
            
        }
    }
    return suceess;
}

- (BOOL)replaceStore:(NSURL *)old withStore:(NSURL *)new {
     if (DEBGU == 1) {  NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    BOOL suceess = NO;
    NSError *error = nil;
    if ([[NSFileManager defaultManager] removeItemAtPath:old.path error:&error]) {
        
        error = nil;
        
        if ([[NSFileManager defaultManager] moveItemAtURL:new toURL:old error:&error]) {
            suceess = YES;
        }else {
            
            if (DEBGU == 1) {
                NSLog(@"Failed to re-home new store:%@",error);
            }
        }
    }else {
        if (DEBGU == 1) {
            NSLog(@"Failed to remove old store:%",error);
        }
    }
    return suceess;
}

// 监听数据迁移进度

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"migrationProgress"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
//            float progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
//
//            self.migrationVC.progressView.progress = progress;
//            int percentage = progress * 100;
//            NSString *string = [NSString stringWithFormat:@"Migration Progress %d%%",percentage];
//            self.migrationVC.lable.text = string;
//            NSLog(@"%@", string);
        });
        
    }
}

#if 0
- (void)performBackgroundManagerMigrationForStore:(NSURL *)storeUrl {
    
     if (DEBGU == 1) {  NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    UIStoryboard *sb  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.migrationVC = [sb instantiateViewControllerWithIdentifier:@"migration"];
    UIApplication *sa = [UIApplication sharedApplication];
    UINavigationController *nav = (UINavigationController *)sa.keyWindow.rootViewController;
    [nav presentViewController:self.migrationVC animated:YES completion:nil];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        BOOL done = [self migrationStore:storeUrl];
        if (done) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSError *error = nil;
                _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[ self storeURL] options:nil error:&error];
                if (!_store) {
                    NSLog(@"Failed to add a migrated store: %@",error); abort();
                }else {
                    NSLog(@"Successfully added migration store: %@", _store);
                    [self.migrationVC dismissViewControllerAnimated:NO completion:nil];
                    self.migrationVC = nil;
                }
            });
        }
    });
}

#endif





-(void)showValidationError:(NSError *)anError {
    
    if (anError && [anError.domain isEqualToString:@"NSCocoaErrorDomain"]) {
        NSArray *errors = nil;
        NSString *text = @"";
        
        if (anError.code == NSValidationMultipleErrorsError) {
            errors = [anError.userInfo objectForKey:NSDetailedErrorsKey];
        }else {
            errors = [NSArray arrayWithObject:anError];
        }
        
        if (errors && errors.count > 0) {
            for (NSError *error in errors) {
                NSString *entity = [[[error.userInfo objectForKey:@"NSValidationErrorObject"] entity] name];
                NSString *property = [error.userInfo objectForKey:@"NSValidationErrorKey"];
                
                switch (error.code) {
                    case NSValidationRelationshipDeniedDeleteError:
                        text = [text stringByAppendingFormat:@"%@ delete was denied because there are associated %@\n(Error code %li)\n\n",entity, property, error.code];
                        break;
                        
                    default:
                        text = [text stringByAppendingFormat:@"Unhandled error code %li in showValidationError mthod.", error.code];
                        break;
                }
            }
            
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Validation Error" message:text preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertViewController addAction:sure];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertViewController animated:YES completion:nil];
            
        }
    }
    
}



#pragma mark ==================== DATA IMPORTER ====================

- (BOOL)isDefaultDataAlreadyImportedForStoreWithUrl:(NSURL *)url {
    
    NSError *error = nil;
    NSDictionary *dic = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:url options:nil error:&error];
    if (error) {
        NSLog(@"Error reading persistent store metadata:%@",error.localizedDescription);
    }else {
        
        NSNumber *defaultDataAlreadyUmported = [dic valueForKey:@"DefaultDataImported"];
        
        if (![defaultDataAlreadyUmported boolValue]) {
            NSLog(@"Default data has NOT already been imported");
            return NO;
        }
    }        
    return YES;
}


//检测是否需要导入数据
- (void)checkIfDefaultDataNeedsImporting {
    
    if (![self isDefaultDataAlreadyImportedForStoreWithUrl:[self storeURL]]) {
//        self.importAlertView = [UIAlertController alertControllerWithTitle:@"Import Default Data?" message:@"If you never used Grocery Dude before then some default data might help you understand how to use it. Tap 'Import' to import default data. Tap 'Cancle' to skip the import, especially if you're done this beforr on other devices." preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
//        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"Import" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
//        [self.importAlertView addAction:cancleAction];
//        [self.importAlertView addAction:sureAction];
//
//        UIWindow *w = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
//        [w.rootViewController presentViewController:self.importAlertView animated:YES completion:nil];
        
        self.importAlertView = [[UIAlertView alloc]initWithTitle:@"Import Default Data?" message:@"If you never used Grocery Dude before then some default data might help you understand how to use it. Tap 'Import' to import default data. Tap 'Cancle' to skip the import, especially if you're done this beforr on other devices." delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Import", nil];
        [self.importAlertView show];
    }
}


- (void)importFromXML:(NSURL *)url {
    
    self.parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    self.parser.delegate = self;
    NSLog(@"**** START PARSER OF %@", url.path);
    
    [self.parser parse];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    
    NSLog(@"**** END PARSER OF %@", url.path);
}



- (void)setDefaultDataAsImportedForStore:(NSPersistentStore *)aStore {
    
    NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:[[aStore metadata] copy]];
    [dictinary setObject:@YES forKey:@"DefaultDataImported"];
    [self.coordinator setMetadata:dictinary forPersistentStore:aStore];
}

#pragma mark ==================== ALERT DELEGATE ====================

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == self.importAlertView) {
        if (buttonIndex == 1) {
            
            //performBlock 不会堵塞主线程，执行完毕后自动返回。
            [_importContext performBlock:^{
                [self importFromXML:[[NSBundle mainBundle] URLForResource:@"DefaultData" withExtension:@"xml"]];
            }];
        }else {
            NSLog(@"User cancle import default data");
        }
        [self setDefaultDataAsImportedForStore:_store];
    }
}


























@end

