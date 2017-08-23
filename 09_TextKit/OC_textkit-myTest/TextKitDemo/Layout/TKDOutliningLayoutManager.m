//
//  TKDOutliningLayoutManager.m
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import "TKDOutliningLayoutManager.h"

@implementation TKDOutliningLayoutManager
//添加绿色的边框
- (void)drawUnderlineForGlyphRange:(NSRange)glyphRange
                     underlineType:(NSUnderlineStyle)underlineVal
                    baselineOffset:(CGFloat)baselineOffset
                  lineFragmentRect:(CGRect)lineRect
            lineFragmentGlyphRange:(NSRange)lineGlyphRange
                   containerOrigin:(CGPoint)containerOrigin
{
    //glyphRange的location:链接前所有文字的range的length
	// Left border (== position) of first underlined glyph
    /*
     * locationForGlyphAtIndex:函数
     * 获取index所在位置的的location
     */
	CGFloat firstPosition = [self locationForGlyphAtIndex: glyphRange.location].x;
    
	// Right border (== position + width) of last underlined glyph
	CGFloat lastPosition;
	
	// When link is not the last text in line, just use the location of the next glyph
    //lineGlyphRange:整行的range
	if (NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange)) {//link的range小于一行
		lastPosition = [self locationForGlyphAtIndex: NSMaxRange(glyphRange)].x;
	}
	// Otherwise get the end of the actually used rect
	else {//link的range大于一行
        /*
         * lineFragmentUsedRectForGlyphAtIndex:函数
         * 获取index所在行的CTLine的Rect
         */
		lastPosition = [self lineFragmentUsedRectForGlyphAtIndex:NSMaxRange(glyphRange) - 1 effectiveRange:NULL].size.width;
	}
//    NSLog(@"123456 --- %lu --- %lu", (unsigned long)glyphRange.length, (unsigned long)lineGlyphRange.length);

	// Inset line fragment to underlined area
    //原始的lineRect只是一个个框位置不准确
    //下面两句让每个lineRect都能框住对应的字
    lineRect.origin.x += containerOrigin.x;
    lineRect.origin.y += containerOrigin.y;
    //下面两句调整lineRect的位置及大小，适应要框住字体的大小
	lineRect.origin.x += firstPosition;
	lineRect.size.width = lastPosition - firstPosition;
//    NSLog(@"123456 --- %f", lineRect.origin.y);
	// Offset line by container origin
//	NSLog(@"123456 --- %f", containerOrigin.y);
	// Align line to pixel boundaries, passed rects may be
	lineRect = CGRectInset(CGRectIntegral(lineRect), .5, .5);
	[[UIColor greenColor] set];
	[[UIBezierPath bezierPathWithRect: lineRect] stroke];
    /*
     //https://my.oschina.net/u/2340880/blog/406816
    CGRect rect = CGRectMake(0, 0, 100, 100);
    CGRect slice ;
    CGRect remainder;
    CGRectDivide(rect, &slice, &remainder, 60, CGRectMinXEdge);
    NSLog(@" {%@ \n %@}", NSStringFromCGRect(slice), NSStringFromCGRect(remainder));*/
}

@end
