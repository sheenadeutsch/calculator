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
@property   (nonatomic, strong)             NSDictionary *testVariableValues;
@property   (nonatomic,strong)              NSString *descriptionOfProgram;
//@property   (nonatomic)                     NSString *result;

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
    if(self.userIsInTheMiddleOfEnteringAFloat)
        return;
    self.userIsInTheMiddleOfEnteringANumber = YES;
    self.userIsInTheMiddleOfEnteringAFloat = YES;
    self.display.text = [self.display.text stringByAppendingString:@"."];
    self.history.text = [self.history.text stringByAppendingString:@"."];
}


- (IBAction)digitPressed:(UIButton *)sender{
    //declaring a variable called "digit" and sending to sender??
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }   else {
        self.display.text = digit;
        self.UserIsInTheMiddleOfEnteringANumber = YES;
    }
    self.history.text = [self.history.text stringByAppendingString:digit];
}


- (IBAction)variablePressed:(UIButton *)sender {
    NSString *variable = sender.currentTitle;
    self.display.text = variable;
    [self.brain pushVariable:sender.currentTitle];
    [self testVariableValues];
    
}


- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    //self.descriptionOfProgram = [CalculatorBrain descriptionOfProgram:[self.brain program]];//having this descritpionOfProgram = does not affect how the calculator functions ??  
    self.userIsInTheMiddleOfEnteringAFloat = NO;
}


- (IBAction)operationPressed:(UIButton *)sender{
    if([self.brain.program count]>0){
        id result = [self.brain performOperation:sender.currentTitle];
        self.display.text = [NSString stringWithFormat:@"%@", result];
        self.history.text = [NSString stringWithFormat:@"%@ %@ = %@   ", self.history.text, sender.currentTitle, result];
        
        //self.descriptionOfProgram = [CalculatorBrain descriptionOfProgram:[self.brain program]];//having this descritpionOfProgram = does not affect how the calculator functions ??
    }
}


- (IBAction)clearPressed:(UIButton *)sender{
    self.display.text = @"0";
    self.history.text = @"";
    self.equalsIsShown = NO;
    self.UserIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
    [self.brain emptyStack];
}


- (IBAction)backspacePressed:(id)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        if([self.display.text length] > 0) {
            self.display.text = [self.display.text substringToIndex:[self.display.text length] -1];
        } else{
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
            self.userIsInTheMiddleOfEnteringAFloat = NO;
        }
        if(self.history.text.length > 0) {
            self.history.text = [self.history.text substringToIndex:[self.history.text length] -1];
        }
    }
}
//check for floating point and set to NO

- (IBAction)plusMinusPressed:(UIButton *)sender{
    if(self.userIsInTheMiddleOfEnteringANumber){
        if([[self.display.text substringToIndex:1]isEqualToString:@"-"]){
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text=[@"-" stringByAppendingString:self.display.text];
        }
    }
}


- (IBAction)undoPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        // Remove the last digit or point from the display
        self.display.text =[self.display.text substringToIndex:
                            [self.display.text length] - 1];
        
        // If we are left with no digits or a "-" digit
        if ( [self.display.text isEqualToString:@""]
            || [self.display.text isEqualToString:@"-"]) {
            
            [self synchronizeView];
        }
    } else {
        // Remove the last item from the stack and synchronize the view
        [self.brain removeLastItem];
        [self synchronizeView];
    }
}


- (IBAction)test1Pressed:(id)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:-4], @"x",
                               [NSNumber numberWithDouble:3], @"a",
                               [NSNumber numberWithDouble:4], @"b", nil];
    [self synchronizeView];
}


- (IBAction)test2Pressed:(id)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:-5], @"x", nil];
    [self synchronizeView];
}


- (IBAction)test3Pressed:(id)sender {
    self.testVariableValues = nil;
    [self synchronizeView];
}


-(void)synchronizeView {
    // Find the result by running the program passing in the test variable values
    id result = [CalculatorBrain runProgram:self.brain.program
                        usingVariableValues:self.testVariableValues];
    
    // If the result is a string, then display it, otherwise get the Number's description
    if ([result isKindOfClass:[NSString class]]) self.display.text = result;
    else self.display.text = [NSString stringWithFormat:@"%g", [result doubleValue]];
    
    // Now the history label, from the latest description of program
    self.display.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    // And finally the variables text, with a bit of formatting
    self.history.text = [[[[[[[self programVariableValues] description]
                             stringByReplacingOccurrencesOfString:@"{" withString:@""]
                            stringByReplacingOccurrencesOfString:@"}" withString:@""]
                           stringByReplacingOccurrencesOfString:@";" withString:@""]
                          stringByReplacingOccurrencesOfString:@"\"" withString:@""]
                         stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
    
    // And the user isn't in the middle of entering a number
    self.userIsInTheMiddleOfEnteringANumber = NO;
}



-(NSDictionary *)programVariableValues{
    
    //find the variables in the current program in the brain as an array
    NSArray *variableArray = [[CalculatorBrain variablesUsedInProgram:self.brain.program] allObjects];
    
    //return a description of a dictionary which contains keys and values for the keys that are in the variable array
    return [self.testVariableValues dictionaryWithValuesForKeys:variableArray];
}


@end
