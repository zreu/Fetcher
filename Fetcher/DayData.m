//
//  DayData.m
//  Fetcher
//
//  Created by Wolfgang Mathurin on 8/10/12.
//  Copyright (c) 2012 Wolfgang Mathurin. All rights reserved.
//

#import "DayData.h"

#define DATE_SEPARATOR @"-"
#define SEPARATOR @","

@interface DayData ()

// Not readonly in the .m
@property(nonatomic,strong) NSDate* date;

@end

@implementation DayData

@synthesize date = _date;
@synthesize open = _open;
@synthesize high = _high;
@synthesize low = _low;
@synthesize close = _close;
@synthesize volume = _volume;
@synthesize adjusted_close = _adjusted_close;

-(void) dealloc
{
    DLog("%p", self);
    [super dealloc];
}

-(id) initWithScanner:(NSScanner *)scanner
{
    self = [super init];
    if (self) {
        self.date = [self scanDate:scanner];
        _open = 100*[self scanNumber:scanner];
        _high = 100*[self scanNumber:scanner];
        _low = 100*[self scanNumber:scanner];
        _close = 100*[self scanNumber:scanner];
        _volume = 100*[self scanNumber:scanner];
        _adjusted_close = 100*[self scanNumber:scanner];
    }
    return self;
}

-(NSDate*) scanDate:(NSScanner*) scanner
{
    int n;
    NSDateComponents* dateComponents = [[[NSDateComponents alloc] init] autorelease];
    [dateComponents setCalendar:[NSCalendar currentCalendar]];
    
    [scanner scanInt:&n];
    [dateComponents setYear:n];
    [scanner scanString:DATE_SEPARATOR intoString:NULL];
    
    [scanner scanInt:&n];
    [dateComponents setMonth:n];
    [scanner scanString:DATE_SEPARATOR intoString:NULL];
    
    [scanner scanInt:&n];
    [dateComponents setDay:n];
    [scanner scanString:SEPARATOR intoString:NULL];
    
//    DLog("dateComponents=%@", dateComponents);

    NSDate* date = [dateComponents date];
//    DLog("date=%@", date);

    return date;
}

-(float) scanNumber:(NSScanner*) scanner
{
    float number;
    [scanner scanFloat:&number];
    [scanner scanString:SEPARATOR intoString:NULL];
    return number;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"%@-->open=%d,high=%d,low=%d,close=%d,volume=%d,adjusted_close=%d", _date, _open, _high, _low, _close, _volume, _adjusted_close];
}

@end
