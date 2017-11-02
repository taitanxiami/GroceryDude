//
//  CoreDataPickerTF.h
//  GroceryDude
//
//  Created by dianda on 2017/10/30.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataHelper.h"
#import <Foundation/Foundation.h>

@class CoreDataPickerTF;
@protocol CoreDataPickerTFDelegate <NSObject>
- (void)selectedObjectID:(NSManagedObjectID *)objectID changedForPickerTF:(CoreDataPickerTF *)pickerTF;
@optional
- (void)selectedObjectClearForPickerTF:(CoreDataPickerTF *)pickerTF;
@end

@interface CoreDataPickerTF : UITextField <UIPickerViewDelegate, UIPickerViewDataSource, UIKeyInput>

@property (weak, nonatomic) id<CoreDataPickerTFDelegate> pickerTFDelegate;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (assign, nonatomic) BOOL showToolBar;
@property (nonatomic, strong) NSManagedObjectID *selectedID;


- (void)fetch;
-(void)selectedDefaultRow;
@end
