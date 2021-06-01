//
//  RenameTIFFAppDelegate.h
//  RenameTIFF
//
//  Created by 内山　和也 on 平成26/03/10.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RenameTIFFAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	NSString *_filePath;
}

@property (assign) IBOutlet NSWindow *window;
@property (copy) NSString *_filePath;

@end
