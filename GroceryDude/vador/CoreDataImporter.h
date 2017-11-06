//
//  CoreDataImporter.h
//  GroceryDude
//
//  Created by dianda on 2017/11/3.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataImporter : NSObject

@property (strong, nonatomic) NSDictionary *entitiesWithUniqueAttribute;


+ (void)saveContext:(NSManagedObjectContext *)context;
- (CoreDataImporter *)initWithUniqueAttributes:(NSDictionary *)attributes;
- (NSString *)uniqueAttibuteForEntity:(NSString *)entity;

- (NSManagedObject *)insertUniqueObjectInTargetEntity:(NSString *)entity
                                 uniqueAttributeValue:(NSString *)uniqueAttributeValue
                                      attributeValues:(NSDictionary *)attributeValues
                                            inContext:(NSManagedObjectContext *)context;


- (NSManagedObject *)insertBasicObjectInTargetEntity:(NSString *)entity
                               targetEntityAttribute:(NSString *)targetAttribute
                                  sourceXMLAttribute:(NSString *)sourceXMLAttribute
                                       attributeDict:(NSDictionary *)attributeDict
                                             context:(NSManagedObjectContext *)context;

@end
