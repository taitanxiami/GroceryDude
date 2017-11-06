//
//  CoreDataImporter.m
//  GroceryDude
//
//  Created by dianda on 2017/11/3.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "CoreDataImporter.h"

@implementation CoreDataImporter


+ (void)saveContext:(NSManagedObjectContext *)context {
    
    [context performBlockAndWait:^{
       
        if ([context hasChanges]) {
            NSError *error = nil;
            if ([context save:&error]) {
                NSLog(@"CoreDataImporter Saved changed from the context to persistent store");
            }else {
                NSLog(@"CoreDataImporter Failed to saved changed from the context to persistent store");
            }
        }
        
    }];
}

- (CoreDataImporter *)initWithUniqueAttributes:(NSDictionary *)uniqueAttributes {
    if (self = [super init]) {
     
        self.entitiesWithUniqueAttribute = uniqueAttributes;
        if (self.entitiesWithUniqueAttribute) {
            return self;
        }else {
            NSLog(@"Failed to initalize CoreDataImporter: entitiesWithUniqueAttribute is nil");
        }
    }
    return nil;
}

- (NSString *)uniqueAttibuteForEntity:(NSString *)entity {
    return [self.entitiesWithUniqueAttribute valueForKey:entity];
}

- (NSManagedObject *)exsitingObjectInContext:(NSManagedObjectContext *)context forEntity:(NSString *)entity withUniqueAttributeValue:(NSString *)uniqueAttributeValue {
    
    NSString *uniqueAttribute = [self uniqueAttibuteForEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", uniqueAttribute, uniqueAttributeValue];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entity];
    [req setPredicate:predicate];
    [req setFetchLimit:1];
    NSError *error = nil;
    NSArray *fecthResults =  [context executeFetchRequest:req error:&error];
    
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    
    if (fecthResults.count == 0) {
        return nil;
    }
    return fecthResults.lastObject;
}

- (NSManagedObject *)insertUniqueObjectInTargetEntity:(NSString *)entity
                                 uniqueAttributeValue:(NSString *)uniqueAttributeValue attributeValues:(NSDictionary *)attributeValues
                                            inContext:(NSManagedObjectContext *)context {
    
    NSString *uniqueAttribute = [self uniqueAttibuteForEntity:entity];
    
    if (uniqueAttributeValue.length > 0) {
        NSManagedObject *exsitingObject = [self exsitingObjectInContext:context forEntity:entity withUniqueAttributeValue:uniqueAttributeValue];
        
        if (exsitingObject) {
            return exsitingObject;
        }else {
            NSManagedObject *newObejct = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:context];
            [newObejct setValuesForKeysWithDictionary:attributeValues];
            return  newObejct;
        }
    }else {        
        NSLog(@"Skipped %@ Object creation:unique attribute value is 0 length",entity);
    }
    return nil;
}

- (NSManagedObject *)insertBasicObjectInTargetEntity:(NSString *)entity targetEntityAttribute:(NSString *)targetAttribute sourceXMLAttribute:(NSString *)sourceXMLAttribute attributeDict:(NSDictionary *)attributeDict context:(NSManagedObjectContext *)context {
    
    NSArray *attributes = [NSArray arrayWithObject:targetAttribute];
    NSArray *values = [NSArray arrayWithObject:[attributeDict valueForKey:sourceXMLAttribute]];
    NSDictionary *attributeValues = [NSDictionary dictionaryWithObjects:values forKeys:attributes];
    return [self insertUniqueObjectInTargetEntity:entity uniqueAttributeValue:[attributeDict valueForKey:sourceXMLAttribute] attributeValues:attributeValues inContext:context];
}





@end
