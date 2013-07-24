//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sheena Deutsch on 7/10/13.
//  Copyright (c) 2013 Sheena Deutsch. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

//@interface is a private property? 
@interface CalculatorViewController()


@property   (nonatomic)         BOOL        userIsInTheMiddleOfEnteringANumber;
@property   (nonatomic)         BOOL        userIsInTheMiddleOfEnteringAFloat;
@property   (nonatomic)         BOOL        equalsIsShown;
@property   (nonatomic, strong)             CalculatorBrain *brain;
@property   (nonatomic, weak)   IBOutlet    UILabel *display;
@property   (nonatomic, weak)   IBOutlet    UILabel *history;
@property   (nonatomic)                     NSMutableArray *dotPressed;
@end

//definitions of methods after @implementation
@implementation CalculatorViewController

-(CalculatorBrain *)brain;{
    //lazy instantiation: only loaded when needed.
    //alloc (allocation): It allocates enough space for all the instance variables.  init(initializing) classes can have multiple, different initalizers in addition to plain init. 
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (IBAction)dotPressed:(id)sender{
    if(!self.userIsInTheMiddleOfEnteringAFloat)
        return;
    self.userIsInTheMiddleOfEnteringANumber = YES;
    self.userIsInTheMiddleOfEnteringAFloat = YES;
    self.display.text = [self.display.text stringByAppendingString:@"."];
}


- (IBAction)digitPressed:(UIButton *)sender{
    //declaring a variable called "digit" and sending to sender??
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }   else{
        self.display.text = digit;
        self.UserIsInTheMiddleOfEnteringANumber = YES;
    }
    self.history.text = self.history.text = [self.history.text stringByAppendingString:digit];
}


- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}


- (IBAction)operationPressed:(UIButton *)sender{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];

    self.history.text = [self.history.text  stringByAppendingString:@"="];
    
    self.equalsIsShown = YES;
}


- (IBAction)clearPressed:(UIButton *)sender{
    self.display.text = @"0";
    self.history.text = @"";
    self.equalsIsShown = NO;
    self.UserIsInTheMiddleOfEnteringANumber = NO;
    [self.brain emptyStack];
}


- (IBAction)backspacePressed:(id)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        if([self.display.text length] > 0) {
            self.display.text = [self.display.text substringToIndex:[self.display.text length] -1];
            self.history.text = [self.history.text substringToIndex:[self.history.text length] -1];
        } else{
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
}


- (IBAction)plusMinusPressed:(UIButton *)sender{
    if(self.userIsInTheMiddleOfEnteringANumber){
        if([[self.display.text substringToIndex:1]isEqualToString:@"-"]){
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text=[@"-" stringByAppendingString:self.display.text];
        }
    }
}


@end
