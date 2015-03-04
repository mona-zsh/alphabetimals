//
//  AATextField.m
//  Alphabetimals
//
//  Created by Mona Zhang on 2/26/15.
//  Copyright (c) 2015 Mona Zhang. All rights reserved.
//

#import "AATextField.h"

@implementation AATextField

- (BOOL)resignFirstResponder {
    if (self.callSuperResignFirstResponder) {
        return [super resignFirstResponder]; // Something in the UIResponder resignFirstResponder
                                             // is allowing reloadData
    } else {
        return YES;
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
}

@end
