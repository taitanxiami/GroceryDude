//
//  LocationAtHomePickerTF.m
//  GroceryDude
//
//  Created by dianda on 2017/11/2.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "LocationAtHomePickerTF.h"

@implementation LocationAtHomePickerTF

// 获取CoreData Unit 对象数据
- (void)fetch {
    
    CoreDataHelper *cdh  = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtHome"];
    NSSortDescriptor *des = [[NSSortDescriptor alloc]initWithKey:@"storedIn" ascending:YES];
    req.sortDescriptors = @[des];
    req.fetchBatchSize = 50;
    
    NSError *error = nil;
    self.pickerData = [cdh.context executeFetchRequest:req error:&error];
    
    if (error) {
        NSLog(@"Error populating picker:%@, %@", error, error.localizedDescription);
    }
    [self selectedDefaultRow];
    
}

- (void)selectedDefaultRow {
    
    
    if (self.selectedID && self.pickerData.count > 0) {
        CoreDataHelper *cdh  = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        LocationAtHome *selectedLocationAtHome = [cdh.context existingObjectWithID:self.selectedID error:nil];
        
        [self.pickerData enumerateObjectsUsingBlock:^(LocationAtHome *locationAtHome, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([locationAtHome.storedIn compare:selectedLocationAtHome.storedIn] == NSOrderedSame) {
                [self.pickerView selectRow:idx inComponent:0 animated:YES];
                [self.pickerTFDelegate selectedObjectID:self.selectedID changedForPickerTF:self];
                *stop = YES;
            }
            
        }];
        
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    LocationAtHome *locationAtHome = [self.pickerData objectAtIndex:row];
    return locationAtHome.storedIn;
}

@end
