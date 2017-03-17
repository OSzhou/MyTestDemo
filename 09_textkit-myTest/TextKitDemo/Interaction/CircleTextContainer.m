//
// CircleTextContainer
// Originally based on code from Apple's TextLayoutDemo. Recalculated to deal with exclusion paths


#import "CircleTextContainer.h"

@implementation CircleTextContainer
//设置段落句式的特殊排版
- (CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect
                                  atIndex:(NSUInteger)characterIndex
                         writingDirection:(NSWritingDirection)baseWritingDirection
                            remainingRect:(CGRect *)remainingRect {

  CGRect rect = [super lineFragmentRectForProposedRect:proposedRect
                                               atIndex:characterIndex
                                      writingDirection:baseWritingDirection
                                         remainingRect:remainingRect];

  CGSize size = [self size];
    //fmin(两者去最小)
  CGFloat radius = fmin(size.width, size.height) / 2.0;
  CGFloat ypos = fabs((proposedRect.origin.y + proposedRect.size.height / 2.0) - radius);
    //sqrt(取平方根)
  CGFloat width = (ypos < radius) ? 2.0 * sqrt(radius * radius - ypos * ypos) : 0.0;
  CGRect circleRect = CGRectMake(radius - width / 2.0, proposedRect.origin.y, width, proposedRect.size.height);

  return CGRectIntersection(rect, circleRect);//返回两个矩形框相交的部分
}

@end
