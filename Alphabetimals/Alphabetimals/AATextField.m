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
//    return NO; // This will come in handy...
    return [super resignFirstResponder];
}

- (void)setText:(NSString *)text {
    [super setText:text];
}

@end
