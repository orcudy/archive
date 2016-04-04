//
//  DataFetch.h
//  Schedule
//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseDataFetcher : NSObject
@property (nonatomic, strong) id delegate;
- (instancetype)initWithClassName:(NSString *)className;

- (void)fetchData;
- (void)addObject:(id)object;
- (void)removeObjectWithID:(NSString *)objectID;
- (void)findObjectsWithKey:(NSString *)key equalTo:(id)testValue;


- (void)fetchDataWithClassName:(NSString *)className;
- (void)addObject:(id)object withClassName:(NSString *)className;
- (void)removeObjectWithID:(NSString *)objectID withClassName:(NSString *)className;
- (void)findObjectsWithKey:(NSString *)key equalTo:(id)testValue withClassName:(NSString *)className;
@end

@protocol ParseDataFetcherCallBackMethods <NSObject>
@optional
- (void)dataFetchSucceeded:(NSArray *)data;
- (void)dataFetchFailed;

- (void)objectAddSucceeded;
- (void)objectAddFailed;

- (void)objectRemoveSucceeded;
- (void)objectRemoveFailed;

- (NSArray *)objectsFound:(NSArray *)notification;
- (void)objectsNotFound;
@end


