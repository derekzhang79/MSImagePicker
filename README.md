MSImagePicker
=============

A image picker controller that supports multiple asset selection, like the Photos App.

# Usage
1. Add MSImagePicker folder to your project
2. #import "MSImagePickerController.h"
3. Init the controller and present it
```    
    MSImagePickerController *picker = [[MSImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
````
4. Implement the delegates
```
- (void)MSImagePickerController:(MSImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
```
