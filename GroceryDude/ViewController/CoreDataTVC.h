//
//  CoreDataTVC.h
//  GroceryDude
//
//  Created by dianda on 2017/10/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTVC : UITableViewController <NSFetchedResultsControllerDelegate>


@property (nonatomic, strong) NSFetchedResultsController *frc;


- (void)performFetch;
@end
