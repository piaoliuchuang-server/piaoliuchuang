//
//  Created by David Alpha Fox on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "NetworkActivityIndicator.h"
#import <pthread.h>
#import <UIKit/UIKit.h>

static int              gSSNetworkTaskCount = 0;
static pthread_mutex_t  gSSMutex = PTHREAD_MUTEX_INITIALIZER;

void SSNetworkRequestStarted(void) {
	pthread_mutex_lock(&gSSMutex);
	
	if (0 == gSSNetworkTaskCount) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	}
	gSSNetworkTaskCount++;
	
	pthread_mutex_unlock(&gSSMutex);
}

void SSNetworkRequestStopped(void) {
	pthread_mutex_lock(&gSSMutex);
	
	--gSSNetworkTaskCount;
	gSSNetworkTaskCount = MAX(0, gSSNetworkTaskCount);
	
	if (gSSNetworkTaskCount == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	}
	
	pthread_mutex_unlock(&gSSMutex);
}
