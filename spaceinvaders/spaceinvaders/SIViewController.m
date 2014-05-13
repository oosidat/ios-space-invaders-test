//
//  SIViewController.m
//  spaceinvaders
//
//  Created by Osama Sidat on 2014-04-14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIViewController.h"
#import "SIGameScene.h"

@interface SIViewController()

@property (nonatomic, getter = isPaused) BOOL paused;
@property (nonatomic, weak) SIGameScene *gameScene;

- (IBAction)pauseButtonAction:(id)sender;

@end

@implementation SIViewController

- (void)viewDidLayoutSubviews
{
    // Configure the view.
    SKView *skView = (SKView *)self.view;
    if (skView) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        SIGameScene *scene = [SIGameScene sceneWithSize:CGSizeMake(320, 480)];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        scene.viewController = self;
        
        self.gameScene = scene;

        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (IBAction)pauseButtonAction:(id)sender {
    if(self.isPaused) {
        [self.gameScene resume];
    } else {
        [self.gameScene pause];
    }
    self.paused = !self.isPaused;
}

@end
