//
//  FlowLayout.m
//  CollectionTest
//
//  Created by B44 on 2017/7/21.
//  Copyright © 2017年 com. All rights reserved.
//

#import "FlowLayout.h"

#define Space 70

@implementation FlowLayout

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)prepareLayout
{
    [super prepareLayout];
    self.cellNumber = (self.collectionView.numberOfSections>0)?(int)[self.collectionView numberOfItemsInSection:0]:0;
    //设置滚动方向 垂直
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置内边距
    self.sectionInset = UIEdgeInsetsMake(120, self.collectionView.frame.size.width-self.itemSize.width, 120, 0);
    //设置两个item之间最小行间距
    self.minimumLineSpacing = Space-self.itemSize.height;
}
/**
 会多次调用的一个方法，当滑出所在范围的时候调用
 即当collectionview的显示范围发生改变，就会调用这个方法（是否重新布局）
 一旦重新刷新布局，就会重新调用
 layoutAttributesForElementsInRect和preparelayout
 **/
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


/***
 手松开就会调用此方法
 这个方法的返回值决定了collectionview在停止滚动时候的偏移量
 proposedContentOffset这个是最终的偏移量的值，但是实际最终还是要根据返回的值来确定
 velocity 是滚动速率 有个x和y 如果x有值 说明x上有速度，如果y有值 说明y上又速度 还可以通过x或者y的正负来判断是左还是右（上还是下滑动）  有时候会有用
 ***/
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //计算最终显示的矩形框
    CGRect rect;
    rect.origin.y = proposedContentOffset.y;
    rect.origin.x = 0;
    rect.size = self.collectionView.frame.size;
   
    //数组里存放在rect范围内所有元素的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    //计算collectionview的最中心点的Y值，因为是最终的中心点所以要考虑惯性
    CGFloat centerY = self.collectionView.frame.size.height/2+proposedContentOffset.y;
    //存放最小的间距
    CGFloat minDelta = MAXFLOAT;
    UICollectionViewLayoutAttributes *tempAttrs;
    for (UICollectionViewLayoutAttributes *attri in array) {
        if (ABS(minDelta)>ABS(attri.center.y-centerY)) {
            minDelta = attri.center.y-centerY;
            tempAttrs = attri;
        }
    }
    //修改原有的偏移量
    proposedContentOffset.y+=minDelta;
    //如果返回zero滑动停止后会立刻返回原地
    return proposedContentOffset;
    
}

- (NSArray *)deepCopyWithArray:(NSArray *)array
{
    NSMutableArray *copys = [NSMutableArray arrayWithCapacity:array.count];
    
    for (UICollectionViewLayoutAttributes *attris in array) {
        [copys addObject:[attris copy]];
    }
    return copys;
}

/***
 当前item居中
 这个方法的返回是一个数组（存放的是rect范围内所有元素的布局属性）
 这个方法的返回值决定了rect范围内所有元素的排布
 ***/
-(nullable NSArray<__kindof UICollectionViewLayoutAttributes *>*)layoutAttributesForElementsInRect:(CGRect)rect
{
    //获取super已经计算好的布局属性，只有线性布局才能使用
    NSArray *array = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:rect]];
//    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    //计算collectionview最中心的Y值
    CGFloat centerY = self.collectionView.contentOffset.y+self.collectionView.frame.size.height/2;
    for (UICollectionViewLayoutAttributes *atts in array) {
        //atts.indexPath.item 表示这个atts对应的cell的位置
        //cell的中心点y和collectionview最中心的y的差值
        CGFloat delta = ABS(atts.center.y - centerY);
        //根据间距值 计算cell的偏移位置
        NSIndexPath *indep = [NSIndexPath indexPathForRow:atts.indexPath.item inSection:0];
        
        atts.zIndex = _cellNumber-delta/70;
        UICollectionViewLayoutAttributes *tempAttri = [self layoutAttributesForItemAtIndexPath:indep];
        tempAttri.zIndex = atts.zIndex;
        atts.center = CGPointMake(atts.center.x+delta, atts.center.y);
        
    }
    return array;
}















@end
