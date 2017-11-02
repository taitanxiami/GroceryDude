//
//  CoreDataPickerTF.m
//  GroceryDude
//
//  Created by dianda on 2017/10/30.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "CoreDataPickerTF.h"

@implementation CoreDataPickerTF



#pragma mark ==================== DELEGATE AND DATASOURCE :UIPICKERVIEW ====================

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 280.0f;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSManagedObject *object = [self.pickerData objectAtIndex:row];
    [self.pickerTFDelegate selectedObjectID:object.objectID changedForPickerTF:self];
}


#pragma mark ==================== INNERACTION ====================

- (void)done {
    [self resignFirstResponder];
}
- (void)clear {
    [self.pickerTFDelegate selectedObjectClearForPickerTF:self];
    [self resignFirstResponder];
}

#pragma mark ==================== DATA ====================
- (void)fetch {
    [NSException raise:NSInternalInconsistencyException format:@"You must override the '%@' method to provide data to the picker", NSStringFromSelector(_cmd)];
}

- (void)selectedDefaultRow {
    [NSException raise:NSInternalInconsistencyException format:@"You must override the '%@' method to set default picker row", NSStringFromSelector(_cmd)];

}


#pragma mark ==================== VIEWS ====================
- (UIView *)creatInputView {
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self fetch];
    return self.pickerView;
}

- (UIView *)creatInputAccessoryView  {
    self.showToolBar = YES;
    if (!self.toolBar && self.showToolBar) {
        self.toolBar = [[UIToolbar alloc]init];
        self.toolBar.barStyle = UIBarStyleBlackTranslucent;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.toolBar sizeToFit];
        CGRect frame = self.toolBar.frame;
        frame.size.height = 44;
        self.toolBar.frame = frame;
        
        UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clear)];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        
        [self.toolBar setItems:@[clearBtn,spacer,doneBtn]];
        
    }
    return self.toolBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.inputView = [self creatInputView];
        self.inputAccessoryView = [self creatInputAccessoryView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        
        self.inputView = [self creatInputView];
        self.inputAccessoryView = [self creatInputAccessoryView];

    }
    return self;
}

- (void)deviceDidRote:(NSNotification *)notification {
    [self.pickerView setNeedsLayout];
}
@end

