//
//  DataFetch.m
//  Schedule
//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "ParseDataFetcher.h"
#import "Event.h"

@interface ParseDataFetcher()

@property (nonatomic, strong) NSString *parseClassName;

@end

@implementation ParseDataFetcher

#pragma mark - Initializers

- (instancetype)initWithClassName:(NSString *)className{
    self = [super init];
    if (self){
        self.parseClassName = className;
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.parseClassName = nil;
    }
    return self;
}

#pragma mark - API (Class Name From Parameter)

//fetch developer defined class from parse
- (void)fetchDataWithClassName:(NSString *)className{
    PFQuery *query = [PFQuery queryWithClassName:className];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(dataFetchSucceeded:)]){
                [self.delegate dataFetchSucceeded:objects];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(dataFetchFailed)]){
                [self.delegate dataFetchFailed];
            }
        }
    }];
}

- (void)addObject:(id)object withClassName:(NSString *)className{
    PFObject *pfobject = [PFObject objectWithClassName:className];
    [pfobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if ([self.delegate respondsToSelector:@selector(objectAddSucceeded)]){
                [self.delegate objectAddSucceeded];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(objectAddFailed)]){
                [self.delegate objectAddFailed];
            }
        }
    }];

}

- (void)removeObjectWithID:(NSString *)objectID withClassName:(NSString *)className{
    PFObject *object = [PFObject objectWithoutDataWithClassName:className
                                                       objectId:objectID];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if ([self.delegate respondsToSelector:@selector(objectRemoveSucceeded)]){
                [self.delegate objectRemoveSucceeded];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(objectRemoveFailed)]){
                [self.delegate objectRemoveFailed];
            }
        }
    }];
}

- (void)findObjectsWithKey:(NSString *)key equalTo:(id)testValue withClassName:(NSString *)className{
    PFQuery *query = [PFQuery queryWithClassName:className];
    [query whereKey:key equalTo:testValue];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(objectsFound:)]){
                [self.delegate objectsFound:objects];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(objectsNotFound)]){
                [self.delegate objectsNotFound];
            }
        }
    }];
}

#pragma mark - API (Class Name From Instance)

//fetch data with class name stored in instance
- (void)fetchData{
    if (self.parseClassName){
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([self.delegate respondsToSelector:@selector(dataFetchSucceeded:)]){
                    [self.delegate dataFetchSucceeded:objects];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(dataFetchFailed)]){
                    [self.delegate dataFetchFailed];
                }
            }
        }];
    } else {
        NSLog(@"Error - parseClassName property is nil");
    }
}

- (void)addObject:(id)object{
    if (self.parseClassName){
        PFObject *pfobject = [PFObject objectWithClassName:self.parseClassName];
        [pfobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                if ([self.delegate respondsToSelector:@selector(objectAddSucceeded)]){
                    [self.delegate objectAddSucceeded];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(objectAddFailed)]){
                    [self.delegate objectAddFailed];
                }
            }
        }];
    } else {
        NSLog(@"Error - parseClassName property is nil");
    }
}

- (void)removeObjectWithID:(NSString *)objectID{
    if (self.parseClassName){
        PFObject *object = [PFObject objectWithoutDataWithClassName:self.parseClassName
                                                           objectId:objectID];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                if ([self.delegate respondsToSelector:@selector(objectRemoveSucceeded)]){
                    [self.delegate objectRemoveSucceeded];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(objectRemoveFailed)]){
                    [self.delegate objectRemoveFailed];
                }
            }
        }];
    } else {
        NSLog(@"Error - parseClassName property is nil");
    }
}

- (void)findObjectsWithKey:(NSString *)key equalTo:(id)testValue{
    if (self.parseClassName){
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query whereKey:key equalTo:testValue];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([self.delegate respondsToSelector:@selector(objectsFound:)]){
                    [self.delegate objectsFound:objects];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(objectsNotFound)]){
                    [self.delegate objectsNotFound];
                }
            }
        }];
    } else {
        NSLog(@"Error - parseClassName property is nil");
    }
}

@end
