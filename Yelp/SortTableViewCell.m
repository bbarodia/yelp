//
//  SortTableViewCell.m
//  Yelp
//
//  Created by Biren Barodia on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SortTableViewCell.h"

@interface SortTableViewCell ()


@end

@implementation SortTableViewCell

- (void)awakeFromNib {
    
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSortByDictionary:(NSDictionary *)sortByDictionary :(BOOL)on {
    [self setSortByDictionary:sortByDictionary :NO animated:NO];
}


- (void)setSortByDictionary:(NSDictionary *)sortByDictionaryIn: (BOOL)on animated:(BOOL)animated  {
    _sortByDictionary = sortByDictionaryIn[@"name"];
    NSMutableArray *buttonNames = [NSMutableArray array];
    for (NSDictionary *sorts in _sortByDictionary ) {
        NSString *name = sorts[@"name"];
        NSLog(@"name:%@", name);
        [buttonNames addObject:sorts[@"name"]];
    }
    
    [self.segmentedControl addTarget:self action:@selector(segmentAction:)
                    forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl removeAllSegments];
    [self.segmentedControl  initWithItems:buttonNames];

}

-(void) segmentAction: (UISegmentedControl *) segmentedControl
{
    NSMutableArray *buttonValues = [NSMutableArray array];
    for (NSDictionary *sorts in _sortByDictionary ) {
        [buttonValues addObject:sorts[@"code"]];
    }
    
    // Update the label with the segment number
    NSString *segmentValue = buttonValues[segmentedControl.selectedSegmentIndex];
    NSLog(@"selected value %@", segmentValue);
    [self.delegate sortTableViewCell:self didChangeSelection:segmentValue];
}

@end
