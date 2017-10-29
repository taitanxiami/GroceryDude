//
//  ItemVC.m
//  GroceryDude
//
//  Created by dianda on 2017/10/28.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "ItemVC.h"

@interface ItemVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@end

@implementation ItemVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideKeyBoardWhenBackgroundIsTapped];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [self ensureItemHomeLocationIsNotNull];
    [self ensureItemShopLocationIsNotNull];
    [self refreshInterface];
    if ([self.nameTextField.text isEqualToString:@"New Item"]) {
        self.nameTextField.text = @"";
        [self.nameTextField becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
     CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    [cdh saveContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ==================== INTERACTION  ====================
//点击完成
- (IBAction)done:(id)sender {
    
    [self hideKeyBoard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyBoardWhenBackgroundIsTapped {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}
- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark ==================== DELEGATE ====================

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.nameTextField) {
        if ([self.nameTextField.text isEqualToString:@"New Item"]) {
            self.nameTextField.text = @"";
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    Item *item = [cdh.context existingObjectWithID:self.selectObjectId error:nil];
    if (textField == self.nameTextField) {
        
        if ([textField.text isEqualToString:@""]) {
            self.nameTextField.text = @"New Item";
        }
        item.name = textField.text;
    }else {
        item.quantity = [textField.text floatValue];
    }
}

#pragma mark ==================== VIEW ====================

//刷新页面
- (void)refreshInterface {
    
    if(self.selectObjectId) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *item = [cdh.context existingObjectWithID:self.selectObjectId error:nil];
        self.nameTextField.text = item.name;
        self.quantityTextField.text  = [NSString stringWithFormat:@"%f",item.quantity];
    }
}

 #pragma mark ==================== DATA ====================

- (void)ensureItemHomeLocationIsNotNull {
    if (DEBUG == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.selectObjectId) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *item = [cdh.context existingObjectWithID:self.selectObjectId error:nil];
        if (!item.locationAtHome) {
            
            NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"UnknownLocationAtHome"];
            NSArray *fetchObjects = [cdh.context executeFetchRequest:request error:nil];
            if (fetchObjects.count > 0) {
                item.locationAtHome = fetchObjects.firstObject;
                
            }else {
                LocationAtHome *lcHome = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome" inManagedObjectContext:cdh.context];
                NSError *error = nil;
                
                if (![cdh.context obtainPermanentIDsForObjects:@[lcHome] error:&error]) {
                    NSLog(@"Couldn't obtain a permanent ID for Object %@",error);
                }
                lcHome.storedIn = @"..Unknown Location..";
                item.locationAtHome = lcHome;
            }
        }
        
    }
}

- (void)ensureItemShopLocationIsNotNull {
    
    if (DEBUG == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.selectObjectId) {
        CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
        Item *item = [cdh.context existingObjectWithID:self.selectObjectId error:nil];
        if (!item.locationAtShop) {
            
            NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"UnknownLocationAtShop"];
            NSArray *fetchObjects = [cdh.context executeFetchRequest:request error:nil];
            if (fetchObjects.count > 0) {
                item.locationAtShop = fetchObjects.firstObject;
                
            }else {
                LocationAtShop *lcShop= [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop" inManagedObjectContext:cdh.context];
                NSError *error = nil;
                
                if (![cdh.context obtainPermanentIDsForObjects:@[lcShop] error:&error]) {
                    NSLog(@"Couldn't obtain a permanent ID for Object %@",error);
                }
                lcShop.aisle = @"..Unknown Location..";
                item.locationAtShop = lcShop;
            }
        }
        
    }}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (DEBUG == 1) {
        NSLog(@"Runing %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    
}


@end
