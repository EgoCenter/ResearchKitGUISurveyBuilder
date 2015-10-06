//
//  ORKStepBuilderViewController.m
//  ResearchKitGUISurveyBuilder
//
//  Created by Tim Bellay on 5/7/15.
//  Copyright (c) 2015 Mission Minds. All rights reserved.
//

#import "ORKStepBuilderViewController.h"
#import <ResearchKit/ResearchKit.h>
#import <objc/runtime.h>
#import <ResearchKit/ORKStepViewController.h>
#import <ResearchKit/ORKAnswerFormat.h>

@interface ORKStepBuilderViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, ORKTaskViewControllerDelegate, ORKStepViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *testSurveyButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *steps; //of ORKQuestionStep and ORKFormStep. TB.
@property (strong, nonatomic) NSString *orderedTaskID;
@end

@implementation ORKStepBuilderViewController

static NSString *defaultTaskID = @"defaultTaskID";
static NSString *collectionViewCellID = @"collectionViewCellID";
static NSString *tableViewCellID = @"tableViewCellID";

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	self.collectionView.backgroundColor = [UIColor whiteColor];
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	if (!self.steps) {
		self.steps = [[NSMutableArray alloc] init];
	}
	
	[self.testSurveyButton sizeToFit];
	[self.testSurveyButton addTarget:self action:@selector(testSurvey) forControlEvents:UIControlEventTouchUpInside];
	[self updateUI];
	
	if (!self.orderedTaskID) {
		self.orderedTaskID = defaultTaskID;
	}
}

- (void)updateUI {
	if ([self.steps count]) {
		self.testSurveyButton.enabled = YES;
		self.testSurveyButton.alpha = 1.0;
	} else {
		self.testSurveyButton.enabled = NO;
		self.testSurveyButton.alpha = 0.66;
	}
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.steps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableViewCellID];
	}
	
	cell.textLabel.text = nil;
	cell.detailTextLabel.text = nil;
	
	ORKQuestionStep *step = (ORKQuestionStep *)[self.steps objectAtIndex:indexPath.row];
	NSDictionary *stepDictionary = [[NSDictionary alloc] initWithDictionary:[ORKStepBuilderViewController dictionaryForStep:self.steps[indexPath.row]]];
	
	cell.textLabel.text = step.identifier;
	ORKAnswerFormat *answerFormat = stepDictionary[@"answerFormat"];
	cell.detailTextLabel.text = answerFormat.description;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ORKFormStep *formStep = [[ORKFormStep alloc] initWithIdentifier:@"DefaultFormStepID"];
	NSMutableArray *formStepItems = [NSMutableArray new];
	
	[formStepItems addObject:[[ORKFormItem alloc] initWithIdentifier:@"" text:@"Form Step ID" answerFormat:[ORKAnswerFormat textAnswerFormat]]];
	[formStepItems addObject:[[ORKFormItem alloc] initWithIdentifier:@"" text:@"Text" answerFormat:[ORKAnswerFormat textAnswerFormat]]];
	[formStepItems addObject:[[ORKFormItem alloc] initWithIdentifier:@"" text:@"Title" answerFormat:[ORKAnswerFormat textAnswerFormat]]];
	
	
	formStep.formItems = formStepItems;
	//ORKQuestionStep *step = (ORKQuestionStep *)[self.steps objectAtIndex:indexPath.row];

	//NSDictionary *stepDictionary = [[NSDictionary alloc] initWithDictionary:[ORKStepBuilderViewController dictionaryForStep:step]];
	//ORKQuestionStepViewController *questionStepVC = [[ORKQuestionStepViewController alloc] initWithStep:step];
	//[self presentViewController:questionStepVC animated:YES completion:nil];
	//questionStepVC.delegate = self;

	ORKStepViewController *formStepVC = [[ORKStepViewController alloc] initWithStep:formStep];
	[self presentViewController:formStepVC animated:YES completion:nil];
	formStepVC.delegate = self;
}

- (void)testSurvey {
	ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:defaultTaskID steps:[self.steps copy]];
	ORKTaskViewController *taskViewController = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
	taskViewController.delegate = self;
	[self presentViewController:taskViewController animated:YES completion:nil];
}

#pragma mark - stepViewController Delegates

-(void)stepViewController:(ORKStepViewController * __nonnull)stepViewController didFinishWithNavigationDirection:(ORKStepViewControllerNavigationDirection)direction {
	[stepViewController dismissViewControllerAnimated:YES completion:^{
	}];
}

#pragma mark - CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 18;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
	
	// TODO: need icons or text for each cell corresponding to each questionStep answerFormat. TB.
	
	cell.backgroundColor = [UIColor lightGrayColor];
	cell.layer.cornerRadius = 6.0f;
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	// TODO: handle form step after question step functionality is complete. TB.
	
	NSString *stepID = @"DefaultStepID";
	NSString *formStepID = @"DefaultFormStepID";
	NSString *formItemID = @"DefaultFormItemID";
	
//	ORKFormItem *formItem = [[ORKFormItem alloc] initWithIdentifier:formItemID text:@"Form Item Text" answerFormat:[self answerFormatForIndex:indexPath]];
//	ORKFormStep *step = [[ORKFormStep alloc] initWithIdentifier:formStepID title:@"Form Step Title" text:@"Form Step Text" ];
//	NSMutableArray *formSteps = [NSMutableArray new];
//	[formSteps addObject:formItem];
//	step.formItems = formSteps;
	
	
	ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:stepID title:@"" answer:[self answerFormatForIndex:indexPath]];
	step.text = @"Text";
	step.title = @"Title";
	step.placeholder = @"Placeholder Text";
	
	[self.steps addObject:step];
	[self.tableView reloadData];
	[self updateUI];
}

- (ORKAnswerFormat *)answerFormatForIndex:(NSIndexPath *)indexPath {
	
	// Default values for answerFormat properties. TB.
	NSInteger scaleMaximum = 10;
	NSInteger scaleMinimum = 0;
	NSInteger defaultValue = 0;
	NSInteger step = 1;
	BOOL vertical = NO;
	NSInteger maximumFractionDigits = 2;
	NSArray *imageChoices = [NSArray array];
	ORKChoiceAnswerStyle style = ORKChoiceAnswerStyleSingleChoice;
	NSArray *textChoices = @[@"Choice 1", @"Choice 2"];
	
	NSString *unit = @"units";
	
	// TODO: This would be nice to set the date components in the detail view of the step timeOfDayAnswerFormatWithDefaultComponents. TB.
	NSDateComponents *defaultComponents = [[NSDateComponents alloc] init];
	
	NSDate *defaultDate = [NSDate date];
	NSDate *minimumDate = [NSDate date];
	NSDate *maximumDate = [NSDate date];
	
	// TODO: calendar should not be nil. TB.
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:@"CalendarID"];
	NSInteger maximumLength = 5;
	NSTimeInterval defaultInterval = 60;
	
	switch (indexPath.row) {
		case 0:
			return [ORKAnswerFormat scaleAnswerFormatWithMaximumValue:scaleMaximum
														 minimumValue:scaleMinimum
														 defaultValue:defaultValue
																 step:step
															 vertical:vertical];
			
		case 1:
			return [ORKAnswerFormat continuousScaleAnswerFormatWithMaximumValue:(double)scaleMaximum
																   minimumValue:(double)scaleMinimum
																   defaultValue:(double)defaultValue
														  maximumFractionDigits:maximumFractionDigits
																	   vertical:vertical];
			
		case 2:
			return [ORKAnswerFormat booleanAnswerFormat];
			
		case 3:
			return [ORKAnswerFormat valuePickerAnswerFormatWithTextChoices:textChoices];
			
		case 4:
			return [ORKAnswerFormat choiceAnswerFormatWithImageChoices:imageChoices];
			
		case 5:
			return [ORKAnswerFormat choiceAnswerFormatWithStyle:style
													textChoices:textChoices];
			
		case 6:
			return [ORKAnswerFormat decimalAnswerFormatWithUnit:unit];
		case 7:
			return [ORKAnswerFormat integerAnswerFormatWithUnit:unit];
			
		case 8:
			return [ORKAnswerFormat timeOfDayAnswerFormat];
		case 9:
			return [ORKAnswerFormat timeOfDayAnswerFormatWithDefaultComponents:defaultComponents];
			
		case 10:
			return [ORKAnswerFormat dateTimeAnswerFormat];
		case 11:
			return [ORKAnswerFormat dateTimeAnswerFormatWithDefaultDate:defaultDate
															minimumDate:minimumDate
															maximumDate:maximumDate
															   calendar:calendar];
			
		case 12:
			return [ORKAnswerFormat dateAnswerFormat];
		case 13:
			return [ORKAnswerFormat dateAnswerFormatWithDefaultDate:defaultDate
														minimumDate:minimumDate
														maximumDate:maximumDate
														   calendar:calendar];
			
		case 14:
			return [ORKAnswerFormat textAnswerFormat];
		case 15:
			return [ORKAnswerFormat textAnswerFormatWithMaximumLength:maximumLength];
			
		case 16:
			return [ORKAnswerFormat timeIntervalAnswerFormat];
		case 17:
			return [ORKAnswerFormat timeIntervalAnswerFormatWithDefaultInterval:defaultInterval step:step];
			
		default:
			return [ORKAnswerFormat booleanAnswerFormat];
	}
}

#pragma mark - ORKTaskViewController Delegates
- (void)taskViewController:(ORKTaskViewController * __nonnull)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(nullable NSError *)error {
	
	[taskViewController dismissViewControllerAnimated:YES completion:^{
	}];
	
}

#pragma mark - Serializers

+ (NSDictionary *)dictionaryForStep:(ORKQuestionStep *)step {
	NSMutableArray *propertyNames = [NSMutableArray array];
	
	// Get the names of all properties of our result's class and all its superclasses. Stop when we hit ORKResult.
	Class klass = step.class;
	BOOL done = NO;
	NSArray *propertyNamesForOneClass = nil;
	
	while (klass != nil && ! done) {
		propertyNamesForOneClass = [self classPropsFor:klass];
		
		[propertyNames addObjectsFromArray:propertyNamesForOneClass];
		
		if (klass == [ORKQuestionStep class])
			done = YES;
		else
			klass = [klass superclass];
	}
	
	NSDictionary *propertiesToSave = [step dictionaryWithValuesForKeys: propertyNames];
	return propertiesToSave;
}


+ (NSDictionary *)dictionaryForTask:(ORKOrderedTask *)result {
	NSMutableArray *propertyNames = [NSMutableArray array];
	
	// Get the names of all properties of our result's class and all its superclasses. Stop when we hit ORKResult.
	Class klass = result.class;
	BOOL done = NO;
	NSArray *propertyNamesForOneClass = nil;
	
	while (klass != nil && ! done) {
		propertyNamesForOneClass = [self classPropsFor:klass];
		
		[propertyNames addObjectsFromArray:propertyNamesForOneClass];
		
		if (klass == [ORKOrderedTask class])
			done = YES;
		else
			klass = [klass superclass];
	}
	
	NSDictionary *propertiesToSave = [result dictionaryWithValuesForKeys: propertyNames];
	return propertiesToSave;
	
	//NSDictionary *serializableData = [APCJSONSerializer serializableDictionaryFromSourceDictionary: propertiesToSave];
	//return serializableData;
}



// Code adapted from APCDataArchiver
+ (NSArray *)classPropsFor:(Class)klass {
	if (klass == NULL)
		return nil;
	
	NSMutableArray *results = [NSMutableArray array];
	
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList(klass, &outCount);
	for (i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if(propName) {
			NSString *propertyName = [NSString stringWithUTF8String:propName];
			[results addObject:propertyName];
		}
	}
	
	free(properties);
	
	return [NSArray arrayWithArray:results];
}


@end
