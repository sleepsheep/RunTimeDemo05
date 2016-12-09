//
//  Dog.h
//  runTimeDemo5
//
//  Created by yangL on 16/3/26.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "Animal.h"

@class DogOther;
@interface Dog : Animal

@property (nonatomic, strong) DogOther *dogOther;

- (void)bark;

@end
