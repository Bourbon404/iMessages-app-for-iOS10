//
//  StickerBrowserController.m
//  iMessageAPP
//
//  Created by ZhengWei on 16/6/22.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "StickerBrowserController.h"

@implementation StickerBrowserController
-(NSInteger)numberOfStickersInStickerBrowserView:(MSStickerBrowserView *)stickerBrowserView
{
    return 20;
}
-(MSSticker *)stickerBrowserView:(MSStickerBrowserView *)stickerBrowserView stickerAtIndex:(NSInteger)index
{

    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]];
    MSSticker *ticker = [[MSSticker alloc] initWithContentsOfFileURL:fileURL localizedDescription:@"文本" error:nil];
    
    return ticker;
}

@end
