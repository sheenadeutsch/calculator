//
//CalculatorBrain.m file
//Calculator
//
//Created by Sheena Deutsch on 7/24/2013
//Copyright (c) 2013 Sheena Deutsch.  All rights reserved
//
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain


//getter
-(NSMutableArray *) programStack;
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}


-(void)emptyStack
{
    self.programStack = nil;
}


-(void)clearTopOfStack{
    [self.programStack removeLastObject];
}


-(void)pushVariable:(NSString *)variable{
    [self.programStack addObject:variable];
}


-(void)pushOperation:(NSString *)operation{
    [self.programStack addObject:operation];
}


//push operand and operations on the stack and return a double
-(void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}


//addObject pushes the operation
-(id)performOperation:(NSString *)operation {
	[self pushOperation:operation];
	return [[self class] runProgram:self.programStack];
}


-(void)removeLastItem{
    [self.programStack removeLastObject];
}


//implementing the getter for program
-(id)program
{
    //copy makes a copy so were not handing out our internal state and returns a unmutalble array
    return [self.programStack copy];
}


+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack= [program mutableCopy];
    NSMutableArray *expressionArray = [NSMutableArray array];
    
    // Call recursive method to describe the stack, removing superfluous brackets at the
    // start and end of the resulting expression. Add the result into an expression array
    // and continue if there are still more items in the stack.
    // our description Array, and if the
    while (stack.count > 0) {
        [expressionArray addObject:[self deBracket:[self descriptionOffTopOfStack:stack]]];
    }
    
    // Return a list of comma seperated programs
    return [expressionArray componentsJoinedByString:@","];
}


+(NSString *)deBracket:(NSString *)expression {
    NSString *description = expression;
    
    // Check to see if there is a bracket at the start and end of the expression
    // If so, then strip the description of these brackets and return.
    if ([expression hasPrefix:@"("] && [expression hasSuffix:@")"]) {
        description = [description substringFromIndex:1];
        description = [description substringToIndex:[description length] - 1];
    }
    
    // Also need to do a final check, to cover the case where removing the brackets
    // results in a + b) * (c + d. Have a look at the position of the brackets and
    // if there is a ) before a (, then we need to revert back to expression
    NSRange openBracket = [description rangeOfString:@"("];
    NSRange closeBracket = [description rangeOfString:@")"];
    
    if (openBracket.location <= closeBracket.location) return description;
    else return expression;
}


//get rid of unnecessary parienthese by comparing the last and the second last operation
+(NSString *)supressParienthese:(NSString *)description{
    NSMutableArray *descriptionArray=[[description componentsSeparatedByString:@" "] mutableCopy];
    NSString *lastOperation, *secondOperation;
    for (int i=[descriptionArray count] -1; i>0 && !lastOperation; i--) {
        if([CalculatorBrain isOperation:[descriptionArray objectAtIndex:i]]){
            lastOperation = [descriptionArray objectAtIndex:i];//last operation found
            
            for(int j=i-1; j>0 && !secondOperation; j--){
                if([CalculatorBrain isOperation:[descriptionArray objectAtIndex:j]]){
                    secondOperation =[descriptionArray objectAtIndex:j];
                }
            }
            if(![CalculatorBrain compareOperationPriority:lastOperation vs:secondOperation]){
                [descriptionArray removeObjectAtIndex: i-1];
                [descriptionArray removeObjectAtIndex:0];
            }
        }
    }
    description = [[descriptionArray valueForKey:@"description"]
                   componentsJoinedByString:@" "];
    return description;
}



//compare two operations' priority
+(BOOL)compareOperationPriority:(NSString *)firstOperation vs:(NSString *)secondOperation{
    BOOL result = 0;
    NSDictionary *operationPriority= [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"+",@"1",@"-",@"2",@"*",@"2",@"/",@"3",@"sin",@"cos",@"sqrt", nil];
    int firstOperationLevel = [[operationPriority objectForKey:firstOperation] intValue];
    int secondOperationLevel;
    if (secondOperation) {
        secondOperationLevel = [[operationPriority objectForKey:secondOperation] intValue];
        if (firstOperationLevel > secondOperationLevel) result = 1;
    }
    return result;
}


+ (NSString *)descriptionOffTopOfStack:(NSMutableArray *)stack {
    
    NSString *description;
    
    // Retrieve and remove the object at the top of the stack
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject]; else return @"";
    
    // If the top of stack is an NSNumber then just return it as a NSString
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack description];
    }
    // but if it's an NSString we need to do some formatting
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        // If top of stack is a no operand operation, or it's a variable then we
        // want to return description in the form "x"
        if (![self isOperation:topOfStack] ||
            [self isNoOperand:topOfStack]) {
            description = topOfStack;
        }
        // If the top of stack is one operand operation, then we want to return an
        // expression in the form "f(x)"
        else if ([self isSingleOperandOperation:topOfStack]) {
            // We need to remove any outside brackets on the recursive description
            // because we are going to put some new brackets on.
            NSString *x = [self deBracket:[self descriptionOffTopOfStack:stack]];
            description = [NSString stringWithFormat:@"%@(%@)", topOfStack, x];
        }
        // If the top of stack is a two operand operation then we want to return
        // an expression in the form "x op. y".
        else if ([self isOperation:topOfStack]) {
            NSString *y = [self descriptionOffTopOfStack:stack];
            NSString *x = [self descriptionOffTopOfStack:stack];
            
            // If the top of stack is For + and - we need to add brackets so that
            // we support precedence rules.
            if ([topOfStack isEqualToString:@"+"] ||
                [topOfStack isEqualToString:@"-"]) {
                // String any existing brackets, before re-adding
                description = [NSString stringWithFormat:@"(%@ %@ %@)",
                               [self deBracket:x], topOfStack, [self deBracket:y]];
            }
            // Otherwise, we are dealing with * or / so no need for brackets
            else {
                description = [NSString stringWithFormat:@"%@ %@ %@",
                               x, topOfStack ,y];
            }
        }
    }
    return description ;
}


//break out into single double no operation above

+ (BOOL)isOperation:(NSString *) stringInQuestion
{
    NSSet *operationsSet = [NSSet setWithObjects: @"+", @"-", @"*", @"/", @"sin", @"cos", @"sqrt", @"π", @"+/-", nil];
    return [operationsSet containsObject:stringInQuestion];
}


+ (BOOL)isSingleOperandOperation:(NSString *) operationInQuestion
{
    NSSet *operationSet = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", @"log", nil];
    return [operationSet containsObject:operationInQuestion];
}


+ (BOOL)isNoOperand:(NSString *)operation
{
    return [[NSSet setWithObjects:@"π",@"a",@"b",@"x", nil] containsObject:operation];
}


//pops an operand off the stack
+(id)popOperandOffStack:(NSMutableArray *)stack
{
    	double result = 0;
    
	id topOfStack = [stack lastObject];
	if (topOfStack) [stack removeLastObject]; else return @"0";
    
	// If it's a number then just return it
	if ([topOfStack isKindOfClass:[NSNumber class]]) return topOfStack;
    
	//Otherwise it's a string
	NSString *operation = topOfStack;
    
	// First check the no operand operations
	if ([operation isEqualToString:@"π"]) {
		result = M_PI;
	} // Next the one operand operations
	else if ([self isSingleOperandOperation:operation]) {
		id operand1 = [self popOperandOffStack:stack];
		// If the operand is a number then ok, otherwise we have insufficient operands
		if ([operand1 isKindOfClass:[NSNumber class]]) {
			// Go ahead and do the operations
			if ([operation isEqualToString:@"sin"]) {
				result = sin ([operand1 doubleValue]);
			} else if ([operation isEqualToString:@"cos"]) {
				result = cos ([operand1 doubleValue]);
			} else if ([operation isEqualToString:@"sqrt"]) {
				result = sqrt([operand1 doubleValue]);
			} else if ([operation isEqualToString:@"±"]) {
				result = [operand1 doubleValue] * -1;
			}
		} 
	} // A two operand operation methinks...
	else if ([self isOperation:operation]) {
		id operand1 = [self popOperandOffStack:stack];
		id operand2 = [self popOperandOffStack:stack];
		// Both operands need to be numbers, or we are out of operands
		if ([operand1 isKindOfClass:[NSNumber class]] &&
            [operand2 isKindOfClass:[NSNumber class]]) {
			// Do the operations
			if ([operation isEqualToString:@"+"]) {
				result = [operand2 doubleValue] + [operand1 doubleValue];
			} else if ([@"*" isEqualToString:operation]) {
				result = [operand2 doubleValue] * [operand1 doubleValue];
			} else if ([operation isEqualToString:@"-"]) {
				result = [operand2 doubleValue] - [operand1 doubleValue];
			} else if ([operation isEqualToString:@"/"]) {
				result = [operand2 doubleValue] / [operand1 doubleValue];
			}
		} 
	} 
    
	return [NSNumber numberWithDouble:result];
}

//might need to delete this runProgram
+(id)runProgram:(id)program {
    // Call the new runProgram method with a nil dictionary
    return [self runProgram:program usingVariableValues:nil];
}


+(id)runProgram:(id)program
usingVariableValues:(NSDictionary *)variableValues {
    
    //ensure program is an NSArray
    if (!([program isKindOfClass:[NSArray class]])) return 0;
    
    NSMutableArray *stack = [program mutableCopy];
    
    //for each item in the program
    for (int i=0; i < [stack count]; i++) {
        id obj = [stack objectAtIndex:i];
        
        //see whether we think the item is a variable
        if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            id value = [variableValues objectForKey:obj];
            
            //if value is not an instance of NSNumber, set it to zero
            if (![value isKindOfClass:[NSNumber class]]) {
                value = [NSNumber numberWithInt:0];
            }
            //replace program variable with value
            [stack replaceObjectAtIndex:i withObject:value];
        }
    }
    //starting popping off the stack
    return [self popOperandOffStack:stack];
}


+(NSSet *)variablesUsedInProgram:(id)program {
    //ensure program is an NSArray
    if(![program isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableSet *variables = [NSMutableSet set];
    
    //for each item in the program
    for (id obj in program) {
        //if we think its a variable add it to the variables set
        if([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            [variables addObject:obj];
        }
    }
    //return nil if we dont have any variables
    if ([variables count] == 0) return nil; else return [variables copy];
}


@end
