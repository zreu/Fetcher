//
//  HistoryData.h
//  Fetcher
//
//  Created by Wolfgang Mathurin on 8/10/12.
//  Copyright (c) 2012 Wolfgang Mathurin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DayData;

@interface HistoryData : NSObject

@property (strong,nonatomic,readonly) NSString* symbol;
@property (strong,nonatomic,readonly) NSDate* startDate;
@property (strong,nonatomic,readonly) NSDate* endDate;
@property (assign,nonatomic,readonly) NSUInteger count;

- (id) initWithScanner:(NSScanner*) scanner symbol:(NSString*) symbol;

- (DayData*) getData:(NSUInteger) row;

@end

