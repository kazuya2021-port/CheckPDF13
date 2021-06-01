//
//  RenameTIFFAppDelegate.m
//  RenameTIFF
//
//  Created by 内山　和也 on 平成26/03/10.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "RenameTIFFAppDelegate.h"
#include <CoreFoundation/CoreFoundation.h>

@implementation RenameTIFFAppDelegate

@synthesize window;
@synthesize _filePath;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark Init
//----------------------------------------------------------------------------//
- (id)init {
	[super init];
	return self;
}

-(void)awakeFromNib {
}


// パスからファイルリスト取得
- (NSArray*)getFileList:(NSString*)filePath
{
	NSFileManager* mng = [NSFileManager defaultManager];
	NSArray* list = [NSArray arrayWithArray:[mng contentsOfDirectoryAtPath:filePath error:nil]];
	NSMutableArray* ret = [NSMutableArray array];
	for(int i = 0; i < [list count]; i++){
		const unichar c = [[list objectAtIndex:i] characterAtIndex:0];
		if (c != '.') {
			[ret addObject:[list objectAtIndex:i]];
		}
	}
	return [ret copy];
}

// レーベル名かどうか(最後の1文字が数字ならOK)
- (BOOL)isLabel:(NSString*)str isLarge:(BOOL*)isLarge
{
	NSString* lastChar = [str substringFromIndex:(str.length - 1)];
	
	BOOL isOK = YES;
	if ([lastChar isEqualToString:@"0"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"1"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"2"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"3"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"4"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"5"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"6"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"7"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"8"]) {
		*isLarge = NO;
	}
	else if([lastChar isEqualToString:@"9"]) {
		*isLarge = NO;
	}
	else if ([lastChar isEqualToString:@"０"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"１"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"２"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"３"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"４"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"５"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"６"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"７"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"８"]) {
		*isLarge = YES;
	}
	else if([lastChar isEqualToString:@"９"]) {
		*isLarge = YES;
	}
	else {
		isOK = NO;
	}
	return isOK;
}

- (NSArray*)getPDFList:(NSString*)filePath
{
	NSFileManager* mng = [NSFileManager defaultManager];
	NSDirectoryEnumerator* dir_enum = [mng enumeratorAtPath:filePath];
	NSString* filename;
	NSMutableArray* array = [[NSMutableArray alloc] init];
	
	while(filename = [dir_enum nextObject]){
		NSRange rng = [filename rangeOfString:@".pdf"];
		if(rng.location != NSNotFound){
			[array addObject:filename];
		}else {
			rng = [filename rangeOfString:@".PDF"];
			if(rng.location != NSNotFound){
				// あった！
				[array addObject:filename];
			}
		}

	}
	return [array copy];
}

- (BOOL)application:(NSApplication*)theApplication openFile:(NSString*)filePath {
	// ドロップファイルのパス取得
	_filePath = filePath;
	NSString* errorFile = [_filePath stringByAppendingString:@"/error.txt"];
	NSArray* fileList = [self getFileList:_filePath];

	NSMutableArray* errorList = [NSMutableArray array];
	
	for(int i = 0; i < [fileList count]; i++){
		NSMutableString* strTmpPath = [NSMutableString string];
		NSString* file = [fileList objectAtIndex:i];
		
		[strTmpPath appendFormat:@"%@/%@",_filePath,file];
		
		NSFileHandle* filehandle = [NSFileHandle fileHandleForReadingAtPath:strTmpPath];
		if(!filehandle) break;
		NSData* header = [filehandle readDataOfLength:8];
		NSString* headStr = [[NSString alloc] initWithData:header encoding:NSUTF8StringEncoding];
		NSLog(@"%@",headStr);
		if(![headStr isEqualToString:@"%PDF-1.3"])
		{
			[errorList addObject:file];
		}
		/*NSArray* objs = [[file componentsSeparatedByString:@"_"] mutableCopy];
		if(objs.count < 3)
		{
			objs = [file componentsSeparatedByString:@"＿"];
		}
		if(objs.count < 3)
		{
			[errorList addObject:file];
			continue;
		}
		
		// 書名取得(大体前から1番目or2番目に来る)
		for(int k = 0; k < objs.count; k++)
		{
			NSString* tmpSec = [objs objectAtIndex:k];
			BOOL tmp = NO;
			if(tmpSec.length < 4)
			{
				if([self isLabel:tmpSec isLarge:&tmp])
				{
					// 文字数が3文字以下で、最後が数字なら書名とは言えない。
				}
				else {
					bookName = tmpSec;
					break;
				}
			}
			else {
				bookName = tmpSec;
				break;
			}
		}

		
		// レーベル取得
		NSMutableArray* labelArray = [NSMutableArray array];
		for(int k = 0; k < objs.count; k++)
		{
			BOOL isL = NO;
			NSString* tmpSec = [objs objectAtIndex:k];
			if ([[tmpSec substringFromIndex:(tmpSec.length - 1)] isEqualToString:@"("]){
				tmpSec = [tmpSec substringToIndex:(tmpSec.length - 1)];
			}
			if([self isLabel:tmpSec isLarge:&isL])
			{
				// 最後が数字のセクション
				if (isL) {
					// 全角なら半角にする
					NSMutableString* conved = [tmpSec mutableCopy];
					CFStringTransform((CFMutableStringRef)conved, NULL, kCFStringTransformFullwidthHalfwidth, false);
					tmpSec = [conved copy];
					[conved release];
					tmpSec = [tmpSec uppercaseString];
				}
				NSMutableDictionary* dic = [NSMutableDictionary dictionary];
				[dic setObject:[NSNumber numberWithInt:k] forKey:@"secno"];
				[dic setObject:tmpSec forKey:@"content"];
				[labelArray addObject: dic];
				
			}
		}

		if (labelArray.count == 1) {
			// 一つだけなら、それがレーベルとなる？
			labels = [[labelArray objectAtIndex:0] objectForKey:@"content"];
		}
		else if (labelArray.count > 1) {
			// 複数の場合は、secnoが大きいやつがレーベルとなる？
			int m = 0;
			for(int k = 0; k < labelArray.count; k++)
			{
				if(m < [[[labelArray objectAtIndex:k] objectForKey:@"secno"] intValue]){
					m = [[[labelArray objectAtIndex:k] objectForKey:@"secno"] intValue];
					labels = [[labelArray objectAtIndex:k] objectForKey:@"content"];
				}
			}
		}else {
			[errorList addObject:file];
			continue;
		}

		
		[strTmpPath appendFormat:@"%@/%@",_filePath,file];
		
		// 指定フォルダ以下のPDFファイルのリスト取得
		NSString* renameSrcFile;
		NSArray* pdflist = [self getPDFList:strTmpPath];
		
		if(pdflist.count == 0)
		{
			[errorList addObject:file];
			continue;
		}
		if(pdflist.count == 1)
		{
			// リネーム対象PDF!
			renameSrcFile = [[NSMutableString stringWithFormat:@"%@/%@/%@",_filePath,file,[pdflist objectAtIndex:0] ] copy];
		}else {
			// 複数PDFの場合(最大サイズのPDFを抽出)
			NSFileManager* fm = [NSFileManager defaultManager];
			double fsizeMax = 0;
			for(int j = 0; j < pdflist.count; j++)
			{
				strTmpPath = [NSMutableString stringWithFormat:@"%@/%@/%@",_filePath,file,[pdflist objectAtIndex:j]];
				NSDictionary* attr = [fm attributesOfItemAtPath:strTmpPath error:nil];
				NSNumber* fsize = [attr objectForKey:NSFileSize];
				if (fsizeMax < [fsize doubleValue]) {
					fsizeMax = [fsize doubleValue];
					renameSrcFile = [strTmpPath copy];
				}
			}
		}
		NSString* saveFile = [NSString stringWithFormat:@"/%@_%@.pdf", bookName, labels];
		NSString* renameDstFile = [saveFolder stringByAppendingString:saveFile];
		[mng copyItemAtPath:renameSrcFile toPath:renameDstFile error:nil];
		 */
	}

	[errorList writeToFile:errorFile atomically:NO];
	[NSApp terminate:self];
	return YES;
}
@end
