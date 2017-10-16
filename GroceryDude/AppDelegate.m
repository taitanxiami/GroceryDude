//
//  AppDelegate.m
//  GroceryDude
//
//  Created by taitanxiami on 2017/10/15.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "AppDelegate.h"
#import "Item+CoreDataProperties.h"
#define DEBGU 1
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[self cdh] saveContext];
    [self demo];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[self cdh] saveContext];
}

- (CoreDataHelper *)cdh {
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_coreDataHelper) {
        _coreDataHelper = [CoreDataHelper new];
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}

- (void)demo {
    
    if (DEBGU == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSArray *newItems = @[@"Apples",@"Milk",@"Bread",@"Cheese",@"Sausages",@"Butter",@"Orange Juice",@"Cereal",@"Coffee",@"Eggs",@"Tomatoes",@"Fish"];

    for (NSString *itemName in newItems) {
//        插入数据
        Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:_coreDataHelper.context];
        item.name = itemName;
        NSLog(@"Insert New Managerd Object for '%@'",item.name);
    }
    
    
    //获取数据
//    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"Item"];
//     fetch request templates 获取请求模板
//    NSFetchRequest *req = [[[_coreDataHelper model] fetchRequestTemplateForName:@"Test"] copy];
    //对搜索结果排序
//    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
//    req.sortDescriptors = @[sortDes];
    
    //对搜索结果筛选
//    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"name != %@",@"Eggs"];
//    req.predicate = filterPredicate;
//    NSError *error = nil;
//    NSArray *items =  [_coreDataHelper.context executeFetchRequest:req error:&error];
//    if (error) {
//        NSLog(@"Failed to fecth items: %@", error);
//    }else {
//        for (Item *item in items) {
//            NSLog(@"Item name: %@",item.name);
//
//            if([item.name isEqualToString:@"Cereal"]) {
//                [_coreDataHelper.context deleteObject:item];
//            }
//        }
//        //删除的对象模型不会立即删除，需要调用saveContext
//        [_coreDataHelper saveContext];
//    }
    

}
@end
