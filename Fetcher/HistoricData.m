//
//  HistoryData.m
//  Fetcher
//
//  Created by Wolfgang Mathurin on 8/10/12.
//  Copyright (c) 2012 Wolfgang Mathurin. All rights reserved.
//

#import "HistoricData.h"
#import "DayData.h"

@interface HistoricData ()

// Not readonly in the .m
@property (strong,nonatomic) NSString* symbol;
@property (strong,nonatomic) NSDate* startDate;
@property (strong,nonatomic) NSDate* endDate;

@end

@implementation HistoricData

NSMutableArray* _dayDatas;

@synthesize symbol = _symbol;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize count = _count;

@synthesize maxAdjustedClose = _maxAdjustedClose;
@synthesize minAdjustedClose = _minAdjustedClose;
@synthesize maxDayDelta = _maxDayDelta;
@synthesize minDayDelta = _minDayDelta;

- (void) dealloc
{
    DLog("%p", self);
    [_dayDatas release];
    [super dealloc];
}

- initWithScanner:(NSScanner*) scanner  symbol:(NSString*) symbol
{
    self = [super init];
    if (self) {
        _dayDatas = [[NSMutableArray alloc] init];
        while(![scanner isAtEnd]) {
            [scanner scanString:@"\n" intoString:NULL];
            DayData* dayData = [[DayData alloc] initWithScanner:scanner];
//            DLog("dayData=%@", dayData);
            [_dayDatas addObject:dayData];
        }
    }
//    [_dayDatas sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [((DayData*) obj1).date compare:((DayData*) obj2).date];
//    }];
    
    self.symbol = symbol;
    [self analyzeData];
    return self;
}


- (NSInteger) getDelta:(NSUInteger) row
{
    if (row < _count - 1) {
        return [self getData:row].adjusted_close - [self getData:row+1].adjusted_close;
    }
    return 0;
}

- (DayData*) getData:(NSUInteger) row
{
    if (row < _count) {
        return [_dayDatas objectAtIndex:row];
    }
    return nil;
}

- (void) analyzeData
{
    _count = [_dayDatas count];
    self.endDate = ((DayData*)[_dayDatas objectAtIndex:0]).date;
    self.startDate = ((DayData*)[_dayDatas lastObject]).date;
    
    _maxAdjustedClose = 0;
    _minAdjustedClose = NSUIntegerMax;
    _maxDayDelta = NSIntegerMin;
    _minDayDelta = NSIntegerMax;
    
    DayData* dayAfterData = nil;
    for (DayData* dayData in _dayDatas) {
        _maxAdjustedClose = MAX(_maxAdjustedClose, dayData.adjusted_close);
        _minAdjustedClose = MIN(_minAdjustedClose, dayData.adjusted_close);

        if (dayAfterData) {
            NSInteger delta = dayAfterData.adjusted_close - dayData.adjusted_close;
            _maxDayDelta = MAX(_maxDayDelta, delta);
            _minDayDelta = MIN(_minDayDelta, delta);
        }
        dayAfterData = dayData;
    }
}


- (NSString*) description
{
    return [NSString stringWithFormat:@"%@ from %@ to %@", _symbol, _startDate, _endDate];
}

@end
