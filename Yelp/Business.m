//
//  Business.m
//  Yelp
//
//  Created by Biren Barodia on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    NSLog(@"individual business %@", dictionary);
    if (self) {
        self.imageUrl = dictionary[@"image_url"];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        self.distance = [dictionary[@"distance"] floatValue] * 0.000621371;
        self.numReviews = [dictionary[@"review_count"] integerValue];
        NSArray *displayAddress =[dictionary valueForKeyPath:@"location.display_address"];
        NSString *streetAddress = @"";
        NSString *city = @"";
        if ( displayAddress.count >= 2) {
         streetAddress = [dictionary valueForKeyPath:@"location.display_address"][0];
         city = [dictionary valueForKeyPath:@"location.display_address"][1];
        }
        self.addressText = [NSString stringWithFormat:@"%@, %@", streetAddress, city ] ;
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.category = [categoryNames componentsJoinedByString:@" ,"];
        self.name = dictionary[@"name"];
     }
    
    return self;
}

+ (NSArray*) initBusinesses: (NSArray *)dictionary {
    NSMutableArray *businessArray = [NSMutableArray array];
    for (NSDictionary *businessItem in dictionary) {
        Business *business = [[Business alloc] initWithDictionary:businessItem];
        [businessArray addObject:business];
    }
    return businessArray;
}

@end
