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
    //各种属性方法的测试
//    [self characterAttribute];
    [self coreTextFromNet];
}

- (void)coreTextFromNet {
    /*** 一· 翻转画布（坐标系）***/
    /*
     coreText 起初是为OSX设计的，而OSX得坐标原点是左下角，y轴正方向朝上。iOS中坐标原点是左上角，
     y轴正方向向下。
     若不进行坐标转换，则文字从下开始，还是倒着的
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置字形的变换矩阵为不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //平移方法，将画布向上平移一个屏幕高
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    //缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，则相当于以x轴为轴旋转180度
    CGContextScaleCTM(context, 1.0, -1.0);
    
    /*** 二.图片的代理设置 ***/
    /*
     事实上，图文混排就是在要插入图片的位置插入一个富文本类型的占位符。通过CTRUNDelegate设置图片
     */
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:@"这里在测试图文混排，我是一个富文本"];
    CTRunDelegateCallbacks callBacks;
    //memset将已开辟内存空间 callbacks 的首 n 个字节的值设为值 0, 相当于对CTRunDelegateCallbacks内存空间初始化
    memset(&callBacks,0,sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBacks;
    callBacks.getDescent = descentCallBacks;
    callBacks.getWidth = widthCallBacks;
    //创建一个图片尺寸的字典，初始化代理对象需要
    NSDictionary * dicPic = @{@"height":@50,@"width":@50};
    //创建代理
    CTRunDelegateRef delegate = CTRunDelegateCreate(& callBacks, (__bridge void *)dicPic);
    //创建空白字符
    unichar placeHolder = 0xFFFC;
    //已空白字符生成字符串
    NSString * placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];
    //用字符串初始化占位符的富文本
    NSMutableAttributedString * placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];
    //给字符串中指定范围的字符串设置代理
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    //释放（__bridge进行C与OC数据类型的转换，C为非ARC，需要手动管理）
    CFRelease(delegate);
    //将占位符插入原富文本
    [attributeStr insertAttributedString:placeHolderAttrStr atIndex:12];
    /*** 三.绘制 （包括两部分） ***/
    /*
     *1.绘制文本
     */
    //一个frame的工厂，负责生成frame
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    //创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    //添加绘制尺寸
    CGPathAddRect(path, NULL, self.bounds);
    NSInteger length = attributeStr.length;
    //工厂根据绘制区域及富文本（可选范围，多次设置）设置frame
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);
    //根据frame绘制文字
    CTFrameDraw(frame, context);
    /*
     *1.绘制图片
     */
    UIImage * image = [UIImage imageNamed:@"add"];
    //图片frame获取
    CGRect imgFrm = [self calculateImageRectWithFrame:frame];
    //绘制图片
    CGContextDrawImage(context,imgFrm, image.CGImage);
    
    //底层内存都要自己管理，记得释放
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}

static CGFloat ascentCallBacks(void * ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}

static CGFloat descentCallBacks(void * ref) {
    return 0;
}

static CGFloat widthCallBacks(void * ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

-(CGRect)calculateImageRectWithFrame:(CTFrameRef)frame {
    //根据frame获取需要绘制的线的数组
    NSArray * arrLines = (NSArray *)CTFrameGetLines(frame);
    //获取线的数量
    NSInteger count = [arrLines count];
    //建立起点的数组（CGPoint类型为结构体，故用C语言数组）
    CGPoint points[count];
    //获取起点
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    for (int i = 0; i < count; i ++) {//遍历数组
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        //获取对应line中的GlyphRun数组（GlyphRun:高效的字符绘制方案）
        NSArray * arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < arrGlyphRun.count; j ++) {//遍历CTRun数组
            //取出CTRun
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            //获取CTRun的属性
            NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);
            //获取代理
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {//代理为空，跳过
                continue;
            }
            //获取代理字典
            NSDictionary * dic = CTRunDelegateGetRefCon(delegate);
            if (![dic isKindOfClass:[NSDictionary class]]) {//为空，跳过
                continue;
            }
            //获取一个点
            CGPoint point = points[i];
            CGFloat ascent;//获取上距
            CGFloat descent;//获取下距
            CGRect boundsRun;//创建一个frame
            //获取宽
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            //获取高
            boundsRun.size.height = ascent + descent;
            //获取x的偏移量
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            //point是行起点位置，加上每个字的偏移量得到每个字的x
#warning 这里的坐标系的原点，好像还是左下角
            boundsRun.origin.x = point.x + xOffset;
            //计算原点
            boundsRun.origin.y = point.y - descent - 23;
//            NSLog(@"123456 --- %f", point.y);
            //获取绘制区域
            CGPathRef path = CTFrameGetPath(frame);
            //获取裁剪区域边框
            CGRect colRect = CGPathGetBoundingBox(path);
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            return imageBounds;
        }
    }
    return CGRectZero;
}

@end
