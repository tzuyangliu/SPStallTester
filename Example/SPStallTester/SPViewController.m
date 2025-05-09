//
//  SPViewController.m
//  SPStallTester
//
//  Created by tzuyangliu on 05/09/2025.
//  Copyright (c) 2025 tzuyangliu. All rights reserved.
//

#import "SPViewController.h"
#import <SPStallTester.h>

@interface SPViewController ()

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    SPStallTestCase *testCase = [[SPStallTestCase alloc] initWithTestName:@"test" testBlock:^BOOL{
        NSLog(@"begin test");
        sleep(6);
        [NSException raise:@"DemoExp" format:@"Error!"];
        return NO;
    } timeCostLimit:5];
    [SPStallTester.sharedInstance runTestWithTestCase:testCase completion:^(SPStallTestTask * _Nonnull task) {
        NSLog(@"completion: %@", task.testResult);
    } expireButFinishBlock:^(SPStallTestTask * _Nonnull task) {
        NSLog(@"expireButFinish: %@", task.expireButFinishTestResult);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
