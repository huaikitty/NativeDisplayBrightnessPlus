//
//  SettingsWindowController.m
//  NativeDisplayBrightness
//
//  Created by Volodymyr Klymenko on 1/28/18.
//  Copyright © 2018 Volodymyr Klymenko. All rights reserved.
//

#import "SettingsWindowController.h"
#import "Config.h"

@interface SettingsWindowController ()

@property (weak) IBOutlet NSButton *decreaseFnShift;
@property (weak) IBOutlet NSButton *decreaseFnControl;
@property (weak) IBOutlet NSButton *decreaseFnOption;
@property (weak) IBOutlet NSButton *decreaseFnCommand;

@property (weak) IBOutlet NSButton *increaseFnShift;
@property (weak) IBOutlet NSButton *increaseFnControl;
@property (weak) IBOutlet NSButton *increaseFnOption;
@property (weak) IBOutlet NSButton *increaseFnCommand;

@property (weak) IBOutlet NSButton *lessWarmFnShift;
@property (weak) IBOutlet NSButton *lessWarmFnControl;
@property (weak) IBOutlet NSButton *lessWarmFnOption;
@property (weak) IBOutlet NSButton *lessWarmFnCommand;

@property (weak) IBOutlet NSButton *moreWarmFnShift;
@property (weak) IBOutlet NSButton *moreWarmFnControl;
@property (weak) IBOutlet NSButton *moreWarmFnOption;
@property (weak) IBOutlet NSButton *moreWarmFnCommand;

@property (weak) IBOutlet NSButton *changeInputSourceFnShift;
@property (weak) IBOutlet NSButton *changeInputSourceFnControl;
@property (weak) IBOutlet NSButton *changeInputSourceFnOption;
@property (weak) IBOutlet NSButton *changeInputSourceFnCommand;

- (NSEventModifierFlags)calculateModifierFlags:(NSEventModifierFlags)modifierFlags sender:(NSButton *)sender;

@end

@implementation SettingsWindowController

-(void)windowDidLoad {
    [super windowDidLoad];

    [self.decreaseBrightnessKey removeAllItems];
    [self.increaseBrightnessKey removeAllItems];
    [self.colorTemperatureLessWarmKey removeAllItems];
    [self.colorTemperatureMoreWarmKey removeAllItems];
    //更改输入源 202009281921
    [self.changeInputSourceKey removeAllItems];
    
    for (int i = 1; i <= 20; i++) {
        NSString *item = [NSString stringWithFormat:@"F%d",i];
        [self.decreaseBrightnessKey addItemWithTitle:item];
        [self.increaseBrightnessKey addItemWithTitle:item];
        [self.colorTemperatureLessWarmKey addItemWithTitle:item];
        [self.colorTemperatureMoreWarmKey addItemWithTitle:item];
        //更改输入源 202009281926
        [self.changeInputSourceKey addItemWithTitle:item];
    }
    [self.increaseBrightnessKey selectItemWithTitle:APP_DELEGATE.increaseBrightnessKey];
    [self.decreaseBrightnessKey selectItemWithTitle:APP_DELEGATE.decreaseBrightnessKey];
    [self.colorTemperatureLessWarmKey selectItemWithTitle:APP_DELEGATE.colorTemperatureLessWarmKey];
    [self.colorTemperatureMoreWarmKey selectItemWithTitle:APP_DELEGATE.colorTemperatureMoreWarmKey];
    
    //更改输入源 202009281927
    [self.changeInputSourceKey
        selectItemWithTitle:APP_DELEGATE.changeInputSourceKey];
    [self.inputSourceCode setPlaceholderString:APP_DELEGATE.inputSourceCode];
    
    self.decreaseFnShift.state = APP_DELEGATE.decreaseFnKey & NSEventModifierFlagShift;
    self.decreaseFnControl.state = APP_DELEGATE.decreaseFnKey & NSEventModifierFlagControl;
    self.decreaseFnOption.state = APP_DELEGATE.decreaseFnKey & NSEventModifierFlagOption;
    self.decreaseFnCommand.state = APP_DELEGATE.decreaseFnKey & NSEventModifierFlagCommand;
    
    self.increaseFnShift.state = APP_DELEGATE.increaseFnKey & NSEventModifierFlagShift;
    self.increaseFnControl.state = APP_DELEGATE.increaseFnKey & NSEventModifierFlagControl;
    self.increaseFnOption.state = APP_DELEGATE.increaseFnKey & NSEventModifierFlagOption;
    self.increaseFnCommand.state = APP_DELEGATE.increaseFnKey & NSEventModifierFlagCommand;
    
    self.lessWarmFnShift.state = APP_DELEGATE.lessWarmFnKey & NSEventModifierFlagShift;
    self.lessWarmFnControl.state = APP_DELEGATE.lessWarmFnKey & NSEventModifierFlagControl;
    self.lessWarmFnOption.state = APP_DELEGATE.lessWarmFnKey & NSEventModifierFlagOption;
    self.lessWarmFnCommand.state = APP_DELEGATE.lessWarmFnKey & NSEventModifierFlagCommand;
    
    self.moreWarmFnShift.state = APP_DELEGATE.moreWarmFnKey & NSEventModifierFlagShift;
    self.moreWarmFnControl.state = APP_DELEGATE.moreWarmFnKey & NSEventModifierFlagControl;
    self.moreWarmFnOption.state = APP_DELEGATE.moreWarmFnKey & NSEventModifierFlagOption;
    self.moreWarmFnCommand.state = APP_DELEGATE.moreWarmFnKey & NSEventModifierFlagCommand;
    
    self.changeInputSourceFnShift.state = APP_DELEGATE.changeInputSourceFnKey & NSEventModifierFlagShift;
    self.changeInputSourceFnControl.state = APP_DELEGATE.changeInputSourceFnKey & NSEventModifierFlagControl;
    self.changeInputSourceFnOption.state = APP_DELEGATE.changeInputSourceFnKey & NSEventModifierFlagOption;
    self.changeInputSourceFnCommand.state = APP_DELEGATE.changeInputSourceFnKey & NSEventModifierFlagCommand;
    
    [self updateKeys];
    
    self.multiMonitor.state = APP_DELEGATE.multiMonitor;
    self.smoothStep.state = APP_DELEGATE.smoothStep;
    self.showBrightness.state = APP_DELEGATE.showBrightness;
    [self.maxBrightness selectItemWithTag: APP_DELEGATE.maxBrightness];
    
    self.adjustColorTemperature.state = APP_DELEGATE.adjustColorTemperature;
    self.colorTemperatureLimit.floatValue = APP_DELEGATE.colorTemperatureLimit;
    
    [self updateColorTemperatureStates:self.adjustColorTemperature.state];
    
    //system not supports it, disable all controls
    if (!APP_DELEGATE.supportsBlueLightReduction) {
        self.adjustColorTemperature.enabled = NO;
        self.colorTemperatureLimit.enabled = NO;
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

- (IBAction)multiMonitor:(NSButton *)sender {
    APP_DELEGATE.multiMonitor = sender.state;
}

- (IBAction)smoothStep:(NSButton *)sender {
    APP_DELEGATE.smoothStep = sender.state;
}

- (IBAction)showBrightness:(NSButton *)sender {
    APP_DELEGATE.showBrightness = sender.state;
    if (sender.state == NSControlStateValueOn) {
        APP_DELEGATE.statusBarIcon.title = [NSString stringWithFormat:@"%i%%",APP_DELEGATE.currentBrightness];
        APP_DELEGATE.statusBarIcon.length = APP_DELEGATE.currentBrightness == 100 ? STATUS_ICON_WIDTH_TEXT_100 : STATUS_ICON_WIDTH_TEXT;
    } else {
        APP_DELEGATE.statusBarIcon.title = @"";
        APP_DELEGATE.statusBarIcon.length = STATUS_ICON_WIDTH;
    }    
}

- (IBAction)changeDecreaseBrightnessKey:(NSPopUpButton *)sender {
    APP_DELEGATE.decreaseBrightnessKey = sender.selectedItem.title;
    [self updateKeys];
}

- (IBAction)changeIncreaseBrightnessKey:(NSPopUpButton *)sender {
    APP_DELEGATE.increaseBrightnessKey = sender.selectedItem.title;
    [self updateKeys];
}

//更改输入源 202009281927
- (IBAction)changeChangeInputSourceKey:(NSPopUpButton *)sender {
    APP_DELEGATE.changeInputSourceKey = sender.selectedItem.title;
    [self updateKeys];
}

- (IBAction)changeInputSourceCode:(NSTextField *)sender {
    APP_DELEGATE.inputSourceCode = sender.stringValue;
    [self updateKeys];
}

- (NSEventModifierFlags)calculateModifierFlags:(NSEventModifierFlags)modifierFlags sender:(NSButton *)sender {
    switch (sender.tag % 10) {
        case 0:
            return sender.state == NSControlStateValueOn ? modifierFlags | NSEventModifierFlagShift : modifierFlags & ~NSEventModifierFlagShift;
        case 1:
            return sender.state == NSControlStateValueOn ? modifierFlags | NSEventModifierFlagControl : modifierFlags & ~NSEventModifierFlagControl;
        case 2:
            return sender.state == NSControlStateValueOn ? modifierFlags | NSEventModifierFlagOption : modifierFlags & ~NSEventModifierFlagOption;
        case 3:
            return sender.state == NSControlStateValueOn ? modifierFlags | NSEventModifierFlagCommand : modifierFlags & ~NSEventModifierFlagCommand;
        default:
            return 0;
    }
}

- (IBAction)changeFunctionKey:(NSButton *)sender {
    switch (sender.tag / 10) {
        case 0:
            APP_DELEGATE.decreaseFnKey = [self calculateModifierFlags:APP_DELEGATE.decreaseFnKey sender:sender];
            break;
        case 1:
            APP_DELEGATE.increaseFnKey = [self calculateModifierFlags:APP_DELEGATE.increaseFnKey sender:sender];
            break;
        case 2:
            APP_DELEGATE.lessWarmFnKey = [self calculateModifierFlags:APP_DELEGATE.lessWarmFnKey sender:sender];
            break;
        case 3:
            APP_DELEGATE.moreWarmFnKey = [self calculateModifierFlags:APP_DELEGATE.moreWarmFnKey sender:sender];
            break;
        case 4:
            APP_DELEGATE.changeInputSourceFnKey = [self calculateModifierFlags:APP_DELEGATE.changeInputSourceFnKey sender:sender];
            break;
            
        default:
            break;
    }
    [self updateKeys];
}

- (IBAction)maxBrightness:(NSPopUpButton *)sender {
    APP_DELEGATE.maxBrightness = (int)sender.selectedTag;
}

- (IBAction)adjustColorTemperature:(NSButton *)sender {
    APP_DELEGATE.adjustColorTemperature = sender.state;
    [self updateColorTemperatureStates:sender.state];
    
    if (!sender.state) {
        [APP_DELEGATE.statusBarMenu removeItem:APP_DELEGATE.colorTemperatureMenu];
    } else {
        [APP_DELEGATE.statusBarMenu insertItem:APP_DELEGATE.colorTemperatureMenu atIndex:1];
    }
}

- (IBAction)colorTemperatureLimit:(NSSlider *)sender {
    APP_DELEGATE.colorTemperatureLimit = sender.floatValue;
}

- (IBAction)changeColorTemperatureLessWarmKey:(NSPopUpButton *)sender {
    APP_DELEGATE.colorTemperatureLessWarmKey = sender.selectedItem.title;
    [self updateKeys];
}

- (IBAction)changeColorTemperatureMoreWarmKey:(NSPopUpButton *)sender {
    APP_DELEGATE.colorTemperatureMoreWarmKey = sender.selectedItem.title;
    [self updateKeys];
}

- (void)updateKeys {

    //needed!? 
//    [self enableAllItems:self.increaseBrightnessKey.itemArray];
//    [self enableAllItems:self.decreaseBrightnessKey.itemArray];
//    [self enableAllItems:self.colorTemperatureLessWarmKey.itemArray];
//    [self enableAllItems:self.colorTemperatureMoreWarmKey.itemArray];
//
//    [self.increaseBrightnessKey itemWithTitle:APP_DELEGATE.decreaseBrightnessKey].enabled = NO;
//    [self.increaseBrightnessKey itemWithTitle:APP_DELEGATE.colorTemperatureLessWarmKey].enabled = NO;
//    [self.increaseBrightnessKey itemWithTitle:APP_DELEGATE.colorTemperatureMoreWarmKey].enabled = NO;
//
//    [self.decreaseBrightnessKey itemWithTitle:APP_DELEGATE.increaseBrightnessKey].enabled = NO;
//    [self.decreaseBrightnessKey itemWithTitle:APP_DELEGATE.colorTemperatureLessWarmKey].enabled = NO;
//    [self.decreaseBrightnessKey itemWithTitle:APP_DELEGATE.colorTemperatureMoreWarmKey].enabled = NO;
//
//    [self.colorTemperatureLessWarmKey itemWithTitle:APP_DELEGATE.increaseBrightnessKey].enabled = NO;
//    [self.colorTemperatureLessWarmKey itemWithTitle:APP_DELEGATE.decreaseBrightnessKey].enabled = NO;
//    [self.colorTemperatureLessWarmKey itemWithTitle:APP_DELEGATE.colorTemperatureMoreWarmKey].enabled = NO;
//
//    [self.colorTemperatureMoreWarmKey itemWithTitle:APP_DELEGATE.increaseBrightnessKey].enabled = NO;
//    [self.colorTemperatureMoreWarmKey itemWithTitle:APP_DELEGATE.decreaseBrightnessKey].enabled = NO;
//    [self.colorTemperatureMoreWarmKey itemWithTitle:APP_DELEGATE.colorTemperatureLessWarmKey].enabled = NO;
}

- (void) enableAllItems:(NSArray *) items {
    for (NSMenuItem *item in items) {
        item.enabled = YES;
    }
}

- (void)updateColorTemperatureStates:(bool) state {
    
    NSColor *color = state ? [NSColor textColor] : [NSColor disabledControlTextColor];
    
    self.colorTemperatureLimit.enabled = state;
    
    self.colorTemperatureLimitLabel.textColor = color;
    self.colorTemperatureLimit.enabled = state;
    
    self.colorTemperatureLessWarmLabel.textColor = color;
    self.colorTemperatureMoreWarmLabel.textColor = color;
    
    self.colorTemperatureLessWarmKeyLabel.textColor = color;
    self.colorTemperatureLessWarmKey.enabled = state;
    
    self.colorTemperatureMoreWarmKeyLabel.textColor = color;
    self.colorTemperatureMoreWarmKey.enabled = state;
    
    self.lessWarmFnShift.enabled = state;
    self.lessWarmFnControl.enabled = state;
    self.lessWarmFnOption.enabled = state;
    self.lessWarmFnCommand.enabled = state;
    
    self.moreWarmFnShift.enabled = state;
    self.moreWarmFnControl.enabled = state;
    self.moreWarmFnOption.enabled = state;
    self.moreWarmFnCommand.enabled = state;
}

@end
