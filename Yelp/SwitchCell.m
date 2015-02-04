//
//  SwitchCell.m
//  Yelp
//
//  Created by Biren Barodia on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell() {
    
}

- (IBAction)switchValueChanged:(id)sender;

@end


@implementation SwitchCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate switchCell:self didUpdateSwitch:self.toggleSwitch.on];
}

- (void) setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void) setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];
}

@end
