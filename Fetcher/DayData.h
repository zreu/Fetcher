//
//  DayData.h
//  Fetcher
//
//  Created by Wolfgang Mathurin on 8/10/12.
//  Copyright (c) 2012 Wolfgang Mathurin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayData : NSObject

@property(nonatomic,strong,readonly) NSDate* date;
@property(nonatomic,assign,readonly) uint open;
@property(nonatomic,assign,readonly) uint high;
@property(nonatomic,assign,readonly) uint low;
@property(nonatomic,assign,readonly) uint close;
@property(nonatomic,assign,readonly) uint volume;
@property(nonatomic,assign,readonly) uint adjusted_close;

-(id) initWithScanner:(NSScanner*) scanner;

@end
