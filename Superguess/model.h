//
//  model.h
//  Superguess
//
//  Created by HZhenF on 17/3/16.
//  Copyright © 2017年 筝风放风筝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface model : UIView

@property(nonatomic,strong) NSString *answer;

@property(nonatomic,strong) NSString *title;

@property(nonatomic,strong) NSString *icon;

@property(nonatomic,strong) NSArray *options;

+(instancetype)modelWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(NSArray *)modelArray;

@end
