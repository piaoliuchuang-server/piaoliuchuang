//
//  MainViewController.m
//  THScreenCaptureViewTest
//
//  Created by wayne li on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

static NSString* rowNames[8] = {@"屏幕正在录制中", @"10秒后自动结束", @"请使劲拖动屏幕", @"以确定录制的是真的视频", 
    @"视频最终将保存到相册中", @"fuck", @"fuck", 
    @"fuck"};


@implementation MainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    aTableView.delegate = self;
    aTableView.dataSource = self;
    [self.view addSubview:aTableView];
    
    capture=[[THCapture alloc] init];
    capture.frameRate=24;
    capture.delegate=self;
    capture.captureLayer=self.view.layer;
    [capture performSelector:@selector(startRecording) withObject:nil afterDelay:1.0];
	[capture performSelector:@selector(stopRecording) withObject:nil afterDelay:11.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc
{
    [capture release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = rowNames[indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark CustomMethod

- (void)video: (NSString *)videoPath
didFinishSavingWithError:(NSError *) error
  contextInfo: (void *)contextInfo{
	if (error) {
		NSLog(@"%@",[error localizedDescription]);
	}
}

- (void)mergedidFinish:(NSString *)videoPath WithError:(NSError *)error
{
    //音频与视频合并结束，存入相册中
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath)) {
		UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
	}
}

#pragma mark -
#pragma mark THCaptureDelegate

- (void)recordingFinished:(NSString*)outputPath
{
    //视频录制结束,为视频加上音乐
    NSString *audioPath=[[NSBundle mainBundle] pathForResource:@"sound.m4a" ofType:nil];
    [THCaptureUtilities mergeVideo:outputPath andAudio:audioPath andTarget:self andAction:@selector(mergedidFinish:WithError:)];
}

- (void)recordingFaild:(NSError *)error
{
    
}

@end
