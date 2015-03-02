//
//  AAAlphabetimal.m
//  Alphabetimals
//
//  Created by Mona Zhang on 2/23/15.
//  Copyright (c) 2015 Mona Zhang. All rights reserved.
//

#import "Alphabetimal.h"

@implementation Alphabetimal

+ (instancetype)alphabetimalWithDictionary:(NSDictionary *)dictionary {
    return [[Alphabetimal alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = [[dictionary[@"AnimalName"] lowercaseString] capitalizedString];
        self.emoji = [NSString
                              stringWithCString:[dictionary[@"Unicode"]cStringUsingEncoding:NSUTF8StringEncoding]
                              encoding:NSNonLossyASCIIStringEncoding];
        self.displayName = [NSString stringWithFormat:@"%@ %@", self.name, self.emoji];
    }
    return self;
}

@end
