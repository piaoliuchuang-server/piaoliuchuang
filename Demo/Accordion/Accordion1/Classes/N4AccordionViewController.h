//
//  RootViewController.h
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/27/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import <UIKit/UIKit.h>
#import "N4FileAccordionDatasourceManager.h"
#import "N4FileSorterViewController.h"

@class DetailViewController;
@class N4FileAccordionDatasourceManager;
@class N4PromptAlertView;

@interface N4AccordionViewController : UIViewController <N4FileAccordionDatasourceManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, N4FilerSorterViewControllerDelegate>{
	IBOutlet UINavigationBar *navigationBar;
	IBOutlet UITableView *tableView;
	
    DetailViewController *detailViewController;
	N4FileAccordionDatasourceManager *datasourceManager;
	NSMutableArray *sortDescriptors;
	UIPopoverController *sorterPopoverController;
	UIPopoverController *fileCreatorPopoverController;
	
	UIAlertView *createFileAlert;
	UIAlertView *createDirectoryAlert;
	UIAlertView *duplicateFileAlert;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) N4FileAccordionDatasourceManager *datasourceManager;
@property (nonatomic, retain) NSMutableArray *sortDescriptors;

- (IBAction) showSortingMenu:(id)sender;

@end
