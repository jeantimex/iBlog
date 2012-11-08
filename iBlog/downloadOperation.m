//
//  downloadOperation.m
//  iBlog
//
//  Created by Yong Su on 18/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "downloadOperation.h"

@implementation downloadOperation

@synthesize urlConnection;
@synthesize done;
@synthesize receiveData;

- (void)start
{
    if (![self isCancelled]) 
    {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        //set up the thread and kick it off...
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSURL *url = [NSURL URLWithString:@"http://google.com"];
        [NSThread detachNewThreadSelector:@selector(download:) toTarget:self withObject:url];
        [self didChangeValueForKey:@"isExecuting"];
    } 
    else 
    {
        // If it's already been cancelled, mark the operation as finished.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (BOOL)isConcurrent 
{
    return YES;
}

- (BOOL)isExecuting 
{
    return executing;
}

- (BOOL)isFinished 
{
    return finished;
}

- (void)download:(NSURL *)url 
{
    done = NO;
    self.receiveData = [NSMutableData data];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
    urlConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (urlConnection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    finished = YES;
    executing = NO;
    // Clean up.
    self.urlConnection = nil;
    
    NSLog(@"download and parse cleaning up");
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark NSURLConnection Delegate methods

// Disable caching so that each time we run this app we are starting with a clean slate.

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse 
{
    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    done = YES;
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    // Process the downloaded chunk of data.
    NSLog(@"Did received %i bytes", [data length]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    // Set the condition which ends the run loop.
    done = YES; 
}

@end
