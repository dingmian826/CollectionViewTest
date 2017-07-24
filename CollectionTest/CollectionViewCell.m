//
//  CollectionViewCell.m
//  CollectionTest
//
//  Created by B44 on 2017/7/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
     
        
        self.showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.showImageView];
        
        

        
    }
    return self;
}

@end
