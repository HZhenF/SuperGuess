//
//  model.m
//  Superguess
//
//  Created by HZhenF on 17/3/16.
//  Copyright © 2017年 筝风放风筝. All rights reserved.
//

#import "model.h"

@implementation model

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+(NSArray *)modelArray
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"questions.plist" ofType:nil]];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrM addObject:[model modelWithDict:dict]];
    }
    return arrM;
}

@end
