//
//  DataFetcher.m
//  Fetcher
//
//  Created by Wolfgang Mathurin on 8/9/12.
//  Copyright (c) 2012 Wolfgang Mathurin. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "DataFetcher.h"

#define BASE_URL @"http://ichart.finance.yahoo.com"
#define ACTION @"table.csv"
#define INT_TO_STRING(n) [NSString stringWithFormat:@"%d", n]

@implementation DataFetcher

@synthesize client = _client;

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

- (id) init {
    if (self = [super init]) {
        [RKClient clientWithBaseURL:BASE_URL];
    }
    return self;
}

- (void) fetchDataForSymbol:(NSString *)symbol {
    NSString* url = [NSString stringWithFormat:@"%@?s=%@", ACTION, symbol];
    DLog("@url=%@", url)
    [self.client get:url usingBlock:^(RKRequest *request) {
        RKResponse* response = request.response;
        DLog(@"response=%@", response.body);
    }];
}

@end