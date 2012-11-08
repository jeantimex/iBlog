//
//  downloadOperation.h
//  iBlog
//
//  Created by Yong Su on 18/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface downloadOperation : NSOperation
{
    @private
    NSURLConnection *urlConnection;
    // Overall state of the parser, used to exit the run loop.
    BOOL done;
    // properties to maintain the NSOperation
    BOOL finished;
    BOOL executing;
}

- (void)download:(NSURL *)url;
- (void)start;
- (BOOL)isConcurrent;
- (BOOL)isFinished;
- (BOOL)isExecuting;

@property BOOL done;
@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (strong, nonatomic) NSMutableData *receiveData;

@end
