//
//  OTPAppDelegate.m
//  Authenticator
//
//  Copyright (c) 2013 Matt Rubin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "OTPAppDelegate.h"
#import "OTPTempManager.h"
#import "OTPAuthURL.h"
#import "OTPRootViewController.h"


@interface OTPAppDelegate () < UIAlertViewDelegate >

@property (nonatomic, strong) OTPTempManager *manager;

@property (nonatomic, strong) UIAlertView *urlAddAlert;
@property (nonatomic, strong) OTPAuthURL *urlBeingAdded;

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) OTPRootViewController *rootViewController;

@end


@implementation OTPAppDelegate

@synthesize window;
@synthesize manager;
@synthesize urlAddAlert;
@synthesize urlBeingAdded;
@synthesize navigationController;
@synthesize rootViewController;


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.manager = [[OTPTempManager alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootViewController = [[OTPRootViewController alloc] init];
    self.rootViewController.delegate = self.manager;
    self.manager.rootViewController = self.rootViewController;
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.navigationController.delegate = self.manager;
    self.manager.navigationController = self.navigationController;
    self.navigationController.toolbarHidden = NO;
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - URL Handling

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    OTPAuthURL *authURL = [OTPAuthURL authURLWithURL:url secret:nil];
    if (authURL) {
        NSString *title = @"Add Token";
        NSString *message = [NSString stringWithFormat: @"Do you want to add the token named “%@”?", [authURL name]];
        NSString *noButton = @"No";
        NSString *yesButton = @"Yes";
        
        self.urlAddAlert = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:self
                                            cancelButtonTitle:noButton
                                            otherButtonTitles:yesButton, nil];
        self.urlBeingAdded = authURL;
        [self.urlAddAlert show];
    }
    return authURL != nil;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.manager entryController:nil didCreateAuthURL:self.urlBeingAdded];
    }
    
    self.urlBeingAdded = nil;
    self.urlAddAlert = nil;
}


@end
