//
//  HistoryData.m
//  Fetcher
//
//  Created by Wolfgang Mathurin on 8/10/12.
//  Copyright (c) 2012 Wolfgang Mathurin. All rights reserved.
//

#import "HistoryData.h"
#import "DayData.h"

@implementation HistoryData

NSMutableArray* _dayDatas;

@synthesize symbol = _symbol;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize count = _count;

- (void) dealloc {
    [_dayDatas release];
    [super dealloc];
}

- initWithScanner:(NSScanner*) scanner  symbol:(NSString*) symbol {
    self = [super init];
    if (self) {
        _dayDatas = [[NSMutableArray array] retain];
        while(![scanner isAtEnd]) {
            [scanner scanString:@"\n" intoString:NULL];
            DayData* dayData = [[DayData alloc] initWithScanner:scanner];
            DLog("dayData=%@", dayData);
            [_dayDatas addObject:dayData];
        }
    }
    [_dayDatas sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((DayData*) obj1).date compare:((DayData*) obj2).date];
    }];
    
    _symbol = symbol;
    _startDate = ((DayData*)[_dayDatas objectAtIndex:0]).date;
    _endDate = ((DayData*)[_dayDatas lastObject]).date;
    _count = [_dayDatas count];
    return self;
}


- (DayData*) getData:(NSUInteger) row {
    if (row < _count) {
        return [_dayDatas objectAtIndex:row];
    }
    return nil;
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ from %@ to %@", _symbol, _startDate, _endDate];
}

@end
