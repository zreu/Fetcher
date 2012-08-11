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
@property(nonatomic,assign,readonly) NSUInteger open;
@property(nonatomic,assign,readonly) NSUInteger high;
@property(nonatomic,assign,readonly) NSUInteger low;
@property(nonatomic,assign,readonly) NSUInteger close;
@property(nonatomic,assign,readonly) NSUInteger volume;
@property(nonatomic,assign,readonly) NSUInteger adjusted_close;

-(id) initWithScanner:(NSScanner*) scanner;

@end
