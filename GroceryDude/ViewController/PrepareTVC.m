//
//  PrepareTVC.m
//  GroceryDude
//
//  Created by dianda on 2017/10/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "PrepareTVC.h"
#import "ItemVC.h"
@interface PrepareTVC ()

@end

@implementation PrepareTVC
#define DEBUG 1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self configureFetch];
    [self performFetch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return self.;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentify = @"prepareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    
    Item *item = [self.frc objectAtIndexPath:indexPath];

    NSMutableString *title = [NSMutableString stringWithFormat:@"%.0f%@ %@",item.quantity, item.unit.name,item.name];
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [title length])];
    cell.textLabel.text = title;
    
    
    //make selected items orange
    
    if ((item.listed)) {
        
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:18]];
        [cell.textLabel setTextColor:[UIColor orangeColor]];
    }else {
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
        [cell.textLabel setTextColor:[UIColor grayColor]];

    }
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Item *deleteItem = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteItem];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }   
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    ItemVC *itemVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemVC"];
    itemVC.selectObjectId = [[self.frc objectAtIndexPath:indexPath] objectID];
    [self.navigationController pushViewController:itemVC animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectID *itemId = [[self.frc objectAtIndexPath:indexPath] objectID];
    
    Item *item = [self.frc.managedObjectContext existingObjectWithID:itemId error:nil];
    
    if (item.listed) {
        item.listed = NO;
    }else {
        item.listed = YES;
        item.collected = NO;
      [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; 
    }
}



-(void)configureFetch {
    if (DEBUG == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtHome.storedIn" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    [req setFetchBatchSize:50];
    self.frc  = [[NSFetchedResultsController alloc]initWithFetchRequest:req managedObjectContext:cdh.context sectionNameKeyPath:@"locationAtHome.storedIn" cacheName:nil];
    
    self.frc.delegate = self;
}
#pragma mark ==================== INTERACTION ====================

//清除清单里面的数据
- (IBAction)clear:(id)sender {
    if (DEBUG == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh =[(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    //     fetch request templates 获取请求模板
    NSFetchRequest *req = [[[cdh model] fetchRequestTemplateForName:@"ShopList"] copy];
    
    NSArray *shopList = [cdh.context executeFetchRequest:req error:nil];
    if (shopList.count > 0) {
        
        UIAlertController *actionSheetViewController = [UIAlertController alertControllerWithTitle:@"Clear Entire Shopping List?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self clearList];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheetViewController addAction:sureAction];
        [actionSheetViewController addAction:cancleAction];
        [self.navigationController presentViewController:actionSheetViewController animated:YES completion:nil];
    }else {
        UIAlertController *actionSheetViewController = [UIAlertController alertControllerWithTitle:@"Nothing to clear" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheetViewController addAction:cancleAction];
        [self.navigationController presentViewController:actionSheetViewController animated:YES completion:nil];
    }
    
}


//清单中的数据全部清除
- (void)clearList {
    
    CoreDataHelper *cdh =[(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    //     fetch request templates 获取请求模板
    NSFetchRequest *req = [[[cdh model] fetchRequestTemplateForName:@"ShopList"] copy];
    NSArray *shopList = [cdh.context executeFetchRequest:req error:nil];
    for (Item *item in shopList) {
        item.listed = NO;
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (DEBUG == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

  
    ItemVC *itemVC = segue.destinationViewController;
  
    if ([segue.identifier isEqualToString:@"Add New Item"]) {
        
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        
        //插入新数据 - 拿到objectID
        Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:cdh.context];
        
        NSError *error = nil;
        if (![cdh.context obtainPermanentIDsForObjects:@[newItem] error:&error]) {
            NSLog(@"Couldn't obtain a permanent ID for object %@", error);
        }
      itemVC.selectObjectId = newItem.objectID;
    }else {
        NSLog(@"unidentified segue attemped");
    }
}
@end
