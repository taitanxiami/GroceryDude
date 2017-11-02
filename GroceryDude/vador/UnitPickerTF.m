//
//  UnitPickerTF.m
//  GroceryDude
//
//  Created by dianda on 2017/11/2.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "UnitPickerTF.h"

@implementation UnitPickerTF




// 获取CoreData Unit 对象数据
- (void)fetch {
    
    CoreDataHelper *cdh  = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
    NSSortDescriptor *des = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
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
        Unit *selectedUnit = [cdh.context existingObjectWithID:self.selectedID error:nil];
        
        [self.pickerData enumerateObjectsUsingBlock:^(Unit *unit, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([unit.name compare:selectedUnit.name] == NSOrderedSame) {
                [self.pickerView selectRow:idx inComponent:0 animated:YES];
                [self.pickerTFDelegate selectedObjectID:self.selectedID changedForPickerTF:self];
                *stop = YES;
            }
            
        }];
        
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    Unit *unit = [self.pickerData objectAtIndex:row];
    return unit.name;
}



@end
