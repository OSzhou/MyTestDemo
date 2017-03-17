//
//  TKDHighlightingTextStorage.m
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import "TKDHighlightingTextStorage.h"


@implementation TKDHighlightingTextStorage
{
	NSMutableAttributedString *_imp;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		_imp = [NSMutableAttributedString new];
	}
	
	return self;
}


#pragma mark - Reading Text

- (NSString *)string
{
	return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
	return [_imp attributesAtIndex:location effectiveRange:range];
}

/** 
 实现两个 setter 方法也几乎同样简单。但也有一个小麻烦：Text Storage 需要通知它的 Layout Manager 变化发生了。因此 settter 方法必须也要调用 -edited:range:changeInLegth: 并传给它变化的描述。听起来更糟糕，实现变成
 */
#pragma mark - Text Editing

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
	[_imp replaceCharactersInRange:range withString:str];
	[self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
	[_imp setAttributes:attrs range:range];
	[self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}


#pragma mark - Syntax highlighting

- (void)processEditing
{
	// Regular expression matching all iWords -- first character i, followed by an uppercase alphabetic character, followed by at least one other character. Matches words like iPod, iPhone, etc.
	static NSRegularExpression *iExpression;
	iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"i[\\p{Alphabetic}&&\\p{Uppercase}][\\p{Alphabetic}]+" options:0 error:NULL];
	
	
	// Clear text color of edited range
	NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
	[self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
	
	// Find all iWords in range
	[iExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		// Add red highlight color
		[self addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
	}];
  
  // Call super *after* changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
  [super processEditing];
}

@end
