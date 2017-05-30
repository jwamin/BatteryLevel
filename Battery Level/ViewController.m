//
//  ViewController.m
//  Battery Level
//
//  Created by Joss Manger on 5/24/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateUI];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self updateUI];
}

-(void)updateUI{
    NSString *percentString = [[NSNumber numberWithFloat:([[UIDevice currentDevice]batteryLevel] * 100.0)]stringValue];
    [_levelLabel setText:[percentString stringByAppendingString:@"%"]];
    [_deviceLabel setText:[[UIDevice currentDevice]name]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
