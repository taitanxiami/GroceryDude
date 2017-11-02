//
//  LocationAtHomeTVC.m
//  GroceryDude
//
//  Created by dianda on 2017/10/29.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "LocationAtHomeTVC.h"
#import "LocationAtHome+CoreDataProperties.h"
#import "LocationAtHomeVC.h"

@interface LocationAtHomeTVC ()


@end

@implementation LocationAtHomeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureFetch];
    [self performFetch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
}


//获取计量单位
- (void)configureFetch {
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtHome"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"storedIn" ascending:YES];
    req.sortDescriptors = @[sort];
    [req setFetchBatchSize:50];
    
    self.frc = [[NSFetchedResultsController alloc]initWithFetchRequest:req managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    
    self.frc.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationAtHome Cell" forIndexPath:indexPath];
    
    LocationAtHome *locationAtHome = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = locationAtHome.storedIn;
    return cell;
}


// Override to support conditional editing of the table view.

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //删除数据源
        LocationAtHome *removeLocationAtHome = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:removeLocationAtHome];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

- (IBAction)done:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //传值
    LocationAtHomeVC *unitVC = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"Add Object Segue"]) {
        
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate  cdh];
        LocationAtHome *locationAtHome = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome" inManagedObjectContext:cdh.context];
        
        NSError *error = nil;
        //把临时id 存储为永久id
        if (![cdh.context obtainPermanentIDsForObjects:@[locationAtHome] error:&error]) {
            NSLog(@"Couldn't obtain a permanent ID object %@",error);
        }
        unitVC.selectedID = locationAtHome.objectID;
        
    }else if ([segue.identifier isEqualToString:@"Edit Object Segue"]) {
        
        //Tips : 获得选中的cell 的indexPath
        NSIndexPath *idx = [self.tableView indexPathForSelectedRow];
        Unit *unit = [self.frc objectAtIndexPath:idx];
        unitVC.selectedID = unit.objectID;
    }else {
        NSLog(@"no right segue");
    }
    
}
@end
