//
//  SortTableViewCell.h
//  Yelp
//
//  Created by Biren Barodia on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SortTableViewCell;

@protocol SortCellDelegate <NSObject>

- (void) sortTableViewCell:(SortTableViewCell *) cell didChangeSelection:(NSString *) value;

@end



@interface SortTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSDictionary *sortByDictionary;
@property (nonatomic, weak) id<SortCellDelegate> delegate;

- (void) setSortByDictionary:(NSDictionary *)sortByDictionary:(BOOL)on animated :(BOOL) animated;

@end
