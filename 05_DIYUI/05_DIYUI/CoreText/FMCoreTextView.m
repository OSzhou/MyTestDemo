//
//  FMCoreTextView.m
//  05_DIYUI
//
//  Created by Windy on 2017/3/10.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMCoreTextView.h"
#import <CoreText/CoreText.h>

@implementation FMCoreTextView

- (void)characterAttribute {
    NSString *str = @"if you love life, life will love you back";
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attriStr beginEditing];//开始编辑
    /*
    long number1 = 1;
    CFNumberRef num1 = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number1    [attriStr addAttribute:(id)kCTCharacterShapeAttributeName value:(__bridge id)num1 range:NSMakeRange(0, 4)];
     
    //设置字体属性
    CTFontRef font = CTFontCreateWithName(CFSTR("Georgia"), 40, NULL);
    [attriStr addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, [str length])];*/
   /*
     //设置字体间隔
    long number2 = 10;
    CFNumberRef num2 = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number2);
    [attriStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num2 range:NSMakeRange(0, [str length])];
    //连字 没啥效果
    long number3 = 1;
    CFNumberRef num3 = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number3);
    [attriStr addAttribute:(id)kCTLigatureAttributeName value:(__bridge id)num3 range:NSMakeRange(0, [str length])];
    //设置字体颜色
    [attriStr addAttribute:(id)kCTForegroundColorAttributeName value:(__bridge id)[UIColor redColor].CGColor range:NSMakeRange(3, 3)];
    //设置字体颜色为前景色
    CFBooleanRef flag = kCFBooleanTrue;
    [attriStr addAttribute:(id)kCTForegroundColorFromContextAttributeName value:(__bridge id)flag range:NSMakeRange(5, 4)];
    //设置空心字
    long number4 = 2;
    CFNumberRef num4 = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number4);
    [attriStr addAttribute:(id)kCTStrokeWidthAttributeName value:(__bridge id)num4  range:NSMakeRange(0, [str length])];
    //设置空心字的颜色（必须先设置字体为空心）
    [attriStr addAttribute:(id)kCTStrokeColorAttributeName value:(__bridge id)[UIColor yellowColor].CGColor range:NSMakeRange(0, [str length])];*/
    
    //对同一段文字进行多属性设置
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    //红色
    [attributes setObject:(id)[UIColor redColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
    //斜体
    CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:20].fontName, 40, NULL);
    
    [attributes setObject:(__bridge id)font forKey:(id)kCTFontAttributeName];
    //下划线
    [attributes setObject:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] forKey:(id)kCTUnderlineStyleAttributeName];
    //下划线颜色
    [attributes setObject:(id)[UIColor yellowColor].CGColor forKey:(id)kCTUnderlineColorAttributeName];
    [attriStr addAttributes:attributes range:NSMakeRange(3, 3)];
    
    [attriStr endEditing];//结束编辑
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(10, -64, self.bounds.size.width - 10, self.bounds.size.height - 10));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    //获取当前（view）上下文以便之后的绘制，这个是一个离屏
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //压栈， 压入图形状态栈中，每个图像上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态不考虑当前路径，所以不保存
    //保存现在的上下文图形状态。不管后续对context上绘制什么都不会影响真正的屏幕。
    CGContextSaveGState(context);
    // x, y轴方向移动
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    //x, y轴方向缩放，-1.0为反方向1.0倍，坐标系转换，沿x轴翻转180度
    CGContextScaleCTM(context, 1.0, -1.0);
    CTFrameDraw(frame, context);
    CGPathRelease(path);
    CFRelease(framesetter);
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self characterAttribute];
}


@end
