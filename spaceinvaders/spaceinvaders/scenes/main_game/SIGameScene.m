//
//  SIMyScene.m
//  spaceinvaders
//
//  Created by Osama Sidat on 2014-04-14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIGameScene.h"
#import "SISpaceship.h"
#import "SIGameScene+collision.h"

#define kRocketRange 1000.0
#define kVelocity 300.0
#define kScoreDisplayName @"scoreDisplay"

@interface SIGameScene()

@property (nonatomic) SISpaceship *spaceship;
@property (nonatomic) SKTexture *monsterTexture;
@property (nonatomic) SKTexture *rocketTexture;
@property (nonatomic) NSTimeInterval timeUntilMonsterSpawn;
@property (nonatomic) NSTimeInterval timeLastUpdate;
@property NSUInteger score;

@end

@implementation SIGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _spaceship = [[SISpaceship alloc] initWithImageNamed:@"Spaceship32.png"];
        _monsterTexture = [SKTexture textureWithImageNamed:@"Monster32.png"];
        _rocketTexture = [SKTexture textureWithImageNamed:@"Rocket32.png"];
    }
    [self setupDisplay];
    return self;
}

-(void)setupDisplay {
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Thin"];
    scoreLabel.name = kScoreDisplayName;
    scoreLabel.fontSize = 12;
    scoreLabel.fontColor = [SKColor blueColor];
    scoreLabel.text = [NSString stringWithFormat:@"Androids Destroyed: %04u", 0];
    scoreLabel.position = CGPointMake(15 + scoreLabel.frame.size.width/2, self.size.height - (15 + scoreLabel.frame.size.height/2));
    
    [self addChild:scoreLabel];
}

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    self.spaceship.position = CGPointMake(self.frame.size.width/2, self.spaceship.size.height);
    [self addChild:self.spaceship];
    
    [self configurePhysics];
}

- (void)addAndroid:(NSTimeInterval)timeSinceLastUpdate {
    self.timeUntilMonsterSpawn -= timeSinceLastUpdate;
    if(self.timeUntilMonsterSpawn > 0) {
        return;
    }
    self.timeUntilMonsterSpawn += [SIRandomGenerator randomTimeIntervalFrom:0.5 to:1.0];
    
    SKSpriteNode *android = [SKSpriteNode spriteNodeWithTexture:self.monsterTexture];
    
    NSInteger androidWidth = android.size.width;
    NSInteger androidHeight = android.size.height;
    
    NSInteger minX = androidWidth;
    NSInteger maxX = self.frame.size.width - androidWidth;
    NSInteger actualX = [SIRandomGenerator randomIntegerFrom:minX to:maxX];
    
    android.position = CGPointMake(actualX, self.frame.size.height);
    [self addChild:android];
    
    NSTimeInterval duration = [SIRandomGenerator randomTimeIntervalFrom:0.5 to:3.0];
    
    SKAction *actionMove = [SKAction moveTo:CGPointMake(actualX, -androidHeight) duration:duration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [android runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    [SIGameScene prepareCollisionForMonster:android];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch * touch = [touches anyObject];
    SKSpriteNode *rocket = [SKSpriteNode spriteNodeWithTexture:self.rocketTexture];
    rocket.position = CGPointMake(self.spaceship.position.x, self.spaceship.position.y + self.spaceship.size.height/2);
    
    [self addChild:rocket];
    
    CGFloat moveDuration = self.size.width / kVelocity;
    
    CGPoint rocketDest = CGPointMake(rocket.position.x, kRocketRange);
    
    SKAction *actionMove = [SKAction moveTo:rocketDest duration:moveDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [rocket runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    [SIGameScene prepareCollisionForRocket:rocket];
}

-(void)addToScore:(NSUInteger)points {
    self.score += points;
    SKLabelNode *score = (SKLabelNode*)[self childNodeWithName:kScoreDisplayName];
    score.text = [NSString stringWithFormat: @"Androids Destroyed: %04lu", (unsigned long)self.score];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    NSTimeInterval timeSinceLastUpdate = currentTime - self.timeLastUpdate;
    if(timeSinceLastUpdate > 1) {
        timeSinceLastUpdate = 1.0/60;
    }
    self.timeLastUpdate = currentTime;
    
    [self addAndroid:timeSinceLastUpdate];
}

@end
