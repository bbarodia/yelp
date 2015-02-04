//
//  Business.h
//  Yelp
//
//  Created by Biren Barodia on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

+ (NSArray*) initBusinesses: (NSArray *)dictionary;

@property (strong, nonatomic) NSString *ratingImageUrl;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *addressText;
@property (assign, nonatomic) NSInteger numReviews;
@property (assign, nonatomic) CGFloat distance;

@end
