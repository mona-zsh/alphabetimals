//
//  AATableViewCell.m
//  Alphabetimals
//
//  Created by Mona Zhang on 2/26/15.
//  Copyright (c) 2015 Mona Zhang. All rights reserved.
//

#import "AATableViewCell.h"

@implementation AATableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16];
    }
    return self;
}

- (BOOL)resignFirstResponder {
    return [super resignFirstResponder];
}

@end
