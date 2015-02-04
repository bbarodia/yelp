//
//  BusinessViewCell.m
//  Yelp
//
//  Created by Biren Barodia on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BusinessViewCell


- (void)awakeFromNib {
    self.mainName.preferredMaxLayoutWidth = self.mainName.frame.size.width ;
    self.mainImage.layer.cornerRadius = 3;
    self.mainImage.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBusiness:(Business *)business {
    _business = business;
    [self.mainImage setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    [self.ratingImage setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
    self.mainName.text = self.business.name;
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    self.addressLabel.text = self.business.addressText;
    self.categoryLabel.text = self.business.category;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance ];
    self.priceIndicator.text = @"$$";
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.mainName.preferredMaxLayoutWidth = self.mainName.frame.size.width;

}
@end
