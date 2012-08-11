//
//  DataFetcher.m
//  Fetcher
//
//  Created by Wolfgang Mathurin on 8/9/12.
//  Copyright (c) 2012 Wolfgang Mathurin. All rights reserved.
//

#import "DataFetcher.h"
#import "HistoricData.h"

#define BASE_URL @"http://ichart.finance.yahoo.com"
#define ACTION @"table.csv"
#define INT_TO_STRING(n) [NSString stringWithFormat:@"%d", n]

@implementation DataFetcher

+ (NSDateComponents*) getComponentsForDate:(NSDate*)date {
    DLog(@"date=%@", date);
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                    fromDate:[NSDate date]];
    DLog(@"dateComponent: day=%d, month=%d, year=%d", [components day], [components month], [components year]);
    return components;
}

+ (NSString*) computeURLForSymbol:(NSString*)symbol fromDate:(NSDate*)fromDate toDate:(NSDate*)toDate {
    NSDateComponents* fromDateComponents = [DataFetcher getComponentsForDate:fromDate];
    NSString* fromYear = INT_TO_STRING([fromDateComponents year]);
    NSString* fromMonth = INT_TO_STRING([fromDateComponents month] - 1);
    NSString* fromDay = INT_TO_STRING([fromDateComponents day]);

    NSDateComponents* toDateComponents = [DataFetcher getComponentsForDate:toDate];
    NSString* toYear = INT_TO_STRING([toDateComponents year]);
    NSString* toMonth = INT_TO_STRING([toDateComponents month] - 1);
    NSString* toDay = INT_TO_STRING([toDateComponents day]);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:symbol    forKey:@"s"];
    [params setObject:fromMonth forKey:@"a"];
    [params setObject:fromDay   forKey:@"b"];
    [params setObject:fromYear  forKey:@"c"];
    [params setObject:toMonth   forKey:@"d"];
    [params setObject:toDay     forKey:@"e"];
    [params setObject:toYear    forKey:@"f"];
    [params setObject:@"d"      forKey:@"g"];
    //[params setObject:@".csv"   forKey:@"ignore"];

    NSString* paramsString = [params stringWithURLEncodedEntries];
    DLog(@"paramsString=%@", paramsString);
    NSString* url = [NSString stringWithFormat:@"%@/%@?%@", BASE_URL, ACTION, paramsString];
    DLog(@"url=%@", url);
    
    return url;
}

- (void) fetchDataForSymbol:(NSString *)symbol onComplete:(void(^)(HistoricData*))block
{
    dispatch_queue_t queue = dispatch_queue_create("fetcher", 0);
    
    dispatch_async(queue, ^{
        
        NSString* urlString = [NSString stringWithFormat:@"%@/%@?s=%@", BASE_URL, ACTION, symbol];
        DLog("@urlString=%@", urlString);
        NSURL* url = [NSURL URLWithString:urlString];
        DLog("@url=%@", url);
        NSError* error = nil;
        
        NSString* response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (response) {
            NSScanner* scanner = [NSScanner scannerWithString:response];
            [scanner scanUpToString:@"\n" intoString:NULL]; // skip header
            HistoricData* historyData = [[[HistoricData alloc] initWithScanner:scanner symbol:symbol] autorelease];
            DLog("historyData=%@", historyData);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(historyData);
            });
        }
        else {
            DLog("@error=%@", error);
        }
    });
}

@end