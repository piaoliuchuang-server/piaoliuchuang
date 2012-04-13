//
//  N4FileSorterViewController.h
//  MandalaChart
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 8/24/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import <UIKit/UIKit.h>

@class N4FileSorterViewController;
@protocol N4FilerSorterViewControllerDelegate
@required 	
- (void) fileSorterViewController:(N4FileSorterViewController *)filerSorterViewController didUpdateDataSource:(NSMutableArray*)datasource;
@end


@interface N4FileSorterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
@private
	NSMutableArray *descriptorsDatasource;
	id <N4FilerSorterViewControllerDelegate> sorterDelegate;
	UITableView *tableView;
}
@property (nonatomic, retain) NSMutableArray *descriptorsDatasource;
@property (nonatomic, assign) id <N4FilerSorterViewControllerDelegate> sorterDelegate;
@end
