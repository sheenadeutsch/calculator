//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sheena Deutsch on 7/10/13.
//  Copyright (c) 2013 Sheena Deutsch. All rights reserved.
//

//include the calculator.h file and calculatorBrain.h file
#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

//@interface is a declaration of what your class can do, visalble to other classes, so other classes can call on methods and access properties of this class?  things defined in @interface of .m file are private. @interface says here comes a class.  Declare instance variables and declare methods under @interface

@interface CalculatorViewController()

//@property auto setter and getter
// nonatomic means not thread safe
@property (nonatomic) BOOL UserIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (nonatomic) BOOL userIsTypingFloatPointNumber;

@end

//definitions of methods after @implementation
@implementation CalculatorViewController

//@synthesize implements properties for us that we dont set in setter and getter.  
//You don't want to name property and vaiables the same = bugs.
@synthesize UserIsInTheMiddleOfEnteringANumber = _UserIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize history = _history;
@synthesize display = _display;
@synthesize userIsTypingFloatPointNumber = _userIsTypingFloatPointNumber;

-(CalculatorBrain *)brain;
{
    //alloc (allocation): heap allocation for a new object is done by the NSObject class method + (id)alloc.  It allocates enough space for all the instance variables.  init(initializing) classes can have multiple, different initalizers in addition to plain init.  both alloc and init must happen one right after the other.
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}



- (IBAction)dotPressed:(id)sender
{
    if (_userIsTypingFloatPointNumber)
        return;
    self.UserIsInTheMiddleOfEnteringANumber = YES;
    self.userIsTypingFloatPointNumber = YES;
    self.display.text = [self.display.text stringByAppendingString:@"."];
}



//instance methods start with "-"
- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    
    if (self.UserIsInTheMiddleOfEnteringANumber)
        self.display.text = [self.display.text stringByAppendingString:digit];
    else{
        self.display.text = digit;
        self.UserIsInTheMiddleOfEnteringANumber = YES;
        
        self.history.text = self.history.text = [self.history.text stringByAppendingString:digit];
    }
}



- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.UserIsInTheMiddleOfEnteringANumber = NO;
}



- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.UserIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}



- (IBAction)clearPressed:(UIButton *)sender
{
   self.history.text = @"";
    self.display.text = @"0";
    _UserIsInTheMiddleOfEnteringANumber = NO;
    [self.brain emptyStack];
}



- (IBAction)backspacePressed:(UIButton *)sender
{
    if (self.UserIsInTheMiddleOfEnteringANumber)
        return;
    
    NSInteger length = self.display.text.length;
    
    if (length > 1)
    {
        if ([[self.display.text substringFromIndex:length-1]isEqualToString:@"."])
            self.userIsTypingFloatPointNumber = NO;
        
        self.display.text = [self.display.text substringFromIndex: length-1];
    }
    else
    {
        self.display.text = @".";
        self.UserIsInTheMiddleOfEnteringANumber = NO;
    }
}

@end
