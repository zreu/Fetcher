//
//  DataFetcher.h
//  Fetcher
//
//  Created by Wolfgang Mathurin on 8/9/12.
//  Copyright (c) 2012 Wolfgang Mathurin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HistoricData;

@interface DataFetcher : NSObject

+ (NSDateComponents*) getComponentsForDate:(NSDate*)date;

+ (NSString*) computeURLForSymbol:(NSString*)symbol fromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;

- (void) fetchDataForSymbol:(NSString*) symbol onComplete:(void(^)(HistoricData*))block;

@end
