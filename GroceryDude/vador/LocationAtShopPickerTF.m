//
//  LocationAtShopPickerTF.m
//  GroceryDude
//
//  Created by dianda on 2017/11/2.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "LocationAtShopPickerTF.h"

@implementation LocationAtShopPickerTF

// 获取CoreData Unit 对象数据
- (void)fetch {
    
    CoreDataHelper *cdh  = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtShop"];
    NSSortDescriptor *des = [[NSSortDescriptor alloc]initWithKey:@"aisle" ascending:YES];
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
        LocationAtShop *selectedLocationAtShop = [cdh.context existingObjectWithID:self.selectedID error:nil];
        
        [self.pickerData enumerateObjectsUsingBlock:^(LocationAtShop *locationAtHome, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selectedLocationAtShop.aisle compare:selectedLocationAtShop.aisle] == NSOrderedSame) {
                [self.pickerView selectRow:idx inComponent:0 animated:YES];
                [self.pickerTFDelegate selectedObjectID:self.selectedID changedForPickerTF:self];
                *stop = YES;
            }
            
        }];
        
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    LocationAtShop *selectedLocationAtShop = [self.pickerData objectAtIndex:row];
    return selectedLocationAtShop.aisle;
}

@end
