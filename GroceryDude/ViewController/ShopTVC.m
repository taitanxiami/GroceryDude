//
//  ShopTVC.m
//  GroceryDude
//
//  Created by dianda on 2017/10/28.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "ShopTVC.h"

@interface ShopTVC ()

@end

@implementation ShopTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self configureFetch];
    [self performFetch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

- (void)configureFetch {
    
    if (DEBUG == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *req = [[[cdh model] fetchRequestTemplateForName:@"ShopList"] copy];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtShop.aisle" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    [req setFetchBatchSize:50];
    
    self.frc  = [[NSFetchedResultsController alloc]initWithFetchRequest:req
                                                   managedObjectContext:cdh.context
                                                     sectionNameKeyPath:@"locationAtShop.aisle" cacheName:nil];
    
    self.frc.delegate = self;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentify = @"shopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    
    Item *item = [self.frc objectAtIndexPath:indexPath];
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%.0f%@ %@",item.quantity, item.unit.name,item.name];
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [title length])];
    cell.textLabel.text = title;
    
    
    //make selected items orange
    
    if ((item.collected)) {
        
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:18]];
        [cell.textLabel setTextColor:[UIColor greenColor]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
        [cell.textLabel setTextColor:[UIColor orangeColor]];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectID *itemId = [[self.frc objectAtIndexPath:indexPath] objectID];
    
    Item *item = [self.frc.managedObjectContext existingObjectWithID:itemId error:nil];
    
    if (item.collected) {
        item.collected = NO;
    }else {
        item.collected = YES;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

//清除购物车数据
- (IBAction)clear:(id)sender {
    
    if (DEBUG == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.frc.fetchedObjects.count == 0) {
        
        UIAlertController *actionSheetViewController = [UIAlertController alertControllerWithTitle:@"Nothing to clear" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheetViewController addAction:cancleAction];
        [self.navigationController presentViewController:actionSheetViewController animated:YES completion:nil];
        return;
    }
    
    BOOL nothingClear = YES;
    
    for (Item *item in self.frc.fetchedObjects) {
        if (item.collected) {
            item.listed = NO;
            item.collected = NO;
            nothingClear = NO;
        }
    }
    
    
    if (nothingClear) {
        UIAlertController *actionSheetViewController = [UIAlertController alertControllerWithTitle:@"Selected items to be removed from the list before pressing Clear" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheetViewController addAction:cancleAction];
        [self.navigationController presentViewController:actionSheetViewController animated:YES completion:nil];
    }
    
}

@end
