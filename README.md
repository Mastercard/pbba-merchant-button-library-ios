# EIS11 PBBA Branded iOS Merchant Button Implementation Guide

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


The Pay by Bank app (PBBA) iOS Merchant Button supports two different models: 
1. Pay by Bank app Branded iOS Merchant Button with Pay by Bank app pop-up
The standard Pay by Bank app iOS Merchant Button with pop-up. This is covered in this document.
2. Pay by Bank app Integrated iOS Merchant Button with Pay by Bank app pop-up
Merchants and Distributors can integrate their payment button with the Pay by Bank app Integrated Web Merchant Button. The additional considerations are covered in the PBBA Integrated iOS Merchant Button Implementation Guide document and should be consulted alongside this document.
Contact your Distributor for any Distributor specific implementation updates or amendments.

## Integrating the Pay by Bank app Branded iOS Merchant Button Library into a Merchant application

The Pay by Bank app Branded iOS Merchant Button Library is for iOS Merchant applications to integrate Pay by Bank app payments.

|      | CocoaPods integration | Manual integration using a static library/framework | Manual integration as subproject |
| ----------- | ----------- |  ----------- |  ----------- |
| Pay by Bank app Merchant Button Library with Merchant App developed in Objective-C      | YES       |  YES       |  YES       |
| Pay by Bank app Merchant Button Library with Merchant App developed in Swift 2.3   | YES        |  YES        |  YES        |
| Pay by Bank app Merchant Button Library with Merchant App developed in Swift 3.0   | YES        |  YES        |  YES        |


## CocoaPods integration
Add the following line to the Podfile if the CocoaPods dependency manager is being used.
### Objective-C projects
pod 'ZappMerchantLib' 
### Swift projects
use_frameworks! 

pod 'ZappMerchantLib'

Then use the following command to install using pods:
```bash
pod install
```

## Manual integration
Build the framework manually from the source and include the output binary into the user project
### Objective-C projects
Follow these procedure steps to generate and integrate the Zapp Merchant Lib framework into the user project.
1. Open the ZappMerchantLib.xcworkspace file.
Note Ensure the workspace is opened – not the project file.
2. Select ZappMerchantSDK scheme from scheme selection drop-down.
3. Run the selected scheme.
4. The folder with build artefacts is exported to ~/Desktop folder. The output folder now contains the following artefacts:
   
 | ZappMerchantLib.framework  | Static framework |
| ------------- | ------------- |
| ZappMerchantLibResources.bundle | Resource bundle |
| clibZappMerchantLib.a  | Static library (optional, to be used instead of ZappMerchantLib.framework)  
| Headers  | Folder to be used together with libZappMerchantLib.a static lib (optional)|
| ZappMerchantLib-docset.zip  | The documentation set.|

5. Add the generated framework ZappMerchantLib.framework to the Link Binary With
Libraries section of the Build Phases project.
6. Add the -ObjC linker flag to the Other Linker Flags field in the Build Settings project.
7. Add ZappMerchantLibResources.bundle to the Copy Bundle Resources section of the Build Phases project.

### Swift projects
The integration steps for Swift projects are the same as for Objective-C plus but with one additional step:
8. Add the ```<ZappMerchantLib/ZappMerchantLib.h>``` import statement to the MerchantApp-Bridging-Header.h file.
#### ```Note It is important to add the library import statement to the Objective-C Bridging Header as it is a static framework which doesn’t define a Swift module.```

### Add the Pay by Bank app Branded iOS Merchant Button Library as subproject
### Objective-C projects
Alternatively you can add the Pay by Bank app Branded iOS Merchant Button Library as a subproject to your app project:
### Procedure
1. Download the ```.zip``` version of the library from Github.
2. ```Unarchive``` the project and copy it to the ```project folder```.
3. Open the project in Xcode then go to the File menu and select the ```Add File to “...”``` option. Browse for the ```ZappMerchantLib.xcodeproj``` file.
4. Go to the ```Link Binary With Libraries``` section of the project ```Build Phases``` and press the plus (+) button. From the list add the ```libZappMerchantLib.a ```static lib to the linked libraries.
5. Add the ```-ObjC linker``` flag to the ```Other Linker Flags``` field in the ```Build Settings``` project.
6. Add ```PATH_TO_MERCHANT_LIB_ROOT_DIRECTORY``` to the ```Header Search Paths``` field
in the ```Build Settings``` project.
7. Go to the ```Copy Bundle Resources``` section of the ```Build Phases``` project and press the plus (+) button. From the list add the ```ZappMerchantLibResources.bundle``` to your resources. If there are no ```ZappMerchantLibResources.bundle``` in the list, drag on drop it from the ```Products``` folder in the ```ZappMerchantLib subproject```.

### Swift projects
The integration steps for Swift projects are the same as for Objective-C plus one additional step:
#### Procedure
1. Add the <ZappMerchantLib/ZappMerchantLib.h> import statement to the
MerchantApp-Bridging-Header.h file.

Note It is important to add the library import statement to the Objective-C
Bridging Header as it is a static library which does not define a Swift module.




## Usage
This section describes the recommended way to use the PBBA Branded iOS Merchant Button Library.

### Set up Pay by Bank App Button
Add a new View to your storyboard / xib layout and change its class to PBBAButton. The following code snippet shows an example of PBBA Button which is connected as an outlet from storyboard / xib to a view controller.
```python
#import <ZappMerchantLib/PBBAButton.h>
@interface ViewController ()
@property (nonatomic, weak) IBOutlet PBBAButton *pbbaButton;
@end
@implementation ViewController
@end
```

The minimum Pay by Bank app Button size should be 320 x 89 points. The Merchant App may display the Pay by Bank app Button in a different size.

#### Important Merchant developer should be aware that if values are set to be too small, the Pay by Bank app Button may not appear correctly. The sizes of the Pay by Bank app brand images are fixed and do not scale up or down if the button size is increased or decreased.

```Note The text within the Pay by Bank app Branded Button (logo and `Pay by Bank app’ text) will not be rendered in the Xcode Interface Builder because it is not IBDesignable enabled. Due to a Xcode IDE limitation where the IBDesignable views are rendered only from the project sources or dynamic frameworks projects included as subprojects, there is no possibility to support the IBDesignable views for the other types of integrations like static libraries, dynamic frameworks included as binaries or CocoaPods integrations.```


### Integration Steps of an M-Comm journey
The steps to integrate the Pay by Bank app Branded iOS Merchant Button of the M-COMM journey in the Merchant App are as follows:
#### Procedure
1. Integrate the Pay by Bank app Branded iOS Button.
2. Submit payment request to Merchant backend.
3. Integrate the Pay by Bank app pop-up (which can invoke the Pay by Bank app CFI App directly).
4. Get payment status from Merchant backend.
5. Dismiss the Pay by Bank app pop-up.
6. Display Merchant payment confirmation screen.


#### Integrate the Pay by Bank app button
As a next step, the Merchant App should display the Pay by Bank app Button. The .onClick event handler of the button should be implemented by the Merchant.

```python
#import <ZappMerchantLib/PBBAButton.h>
@interface ViewController () <PBBAButtonDelegate>
@property (nonatomic, weak) IBOutlet PBBAButton *pbbaButton;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
self.pbbaButton.delegate = self; }
#pragma mark - PBBAButtonDelegate
- (BOOL)pbbaButtonDidPress:(PBBAButton *)pbbaButton {
    // Start the submit payment request
    // If YES returned then button will disable itself and will start default PBBA
animation
// If NO returned then button will not react, remaining enabled.
return YES;
}
@end
```


#### Submit payment request to Merchant backend
The .onClick event handler of the Pay by Bank app Button is called when the Consumer taps to the Pay by Bank app Button. The Merchant has to submit a payment request to the Merchant backend. The format/protocol to use is left open to the Merchant.

#### Integrate the Pay by Bank app pop-up
##### Integrate pop-up for Pay by Bank app M-COMM journey
The Pay by Bank app Branded iOS Merchant Button Library provides a feature to display the Pay by Bank app branded pop-ups for the payment Transaction:

```python
#import <ZappMerchantLib/PBBAAppUtils.h> // Display PBBA popup
[PBBAAppUtils showPBBAPopup:popupPresenter secureToken:secureToken brn:brn
expiryInterval:expiryInterval delegate:popupDelegate];
```

| Parameter name | Parameter description | Parameter source |
|  ------------- |  ------------- |  ------------- |
| popupPresenter | The instance of the view controller which will present the PBBA Pop-up. | Provided by the Merchant App. |
| secureToken | The unique token that identifies the payment request| < Consult Distributor Documentation >|
| brn | The six character code that identifies the payment request for the duration of retrieval timeout period.| < Consult Distributor Documentation >|
| expiryInterval | The time interval | < Consult Distributor Documentation >|
| popupDelegate | The PBBA pop-up delegate instance.| Provided by the Merchant App.|


If the Consumer has tapped the ‘Open banking app’ Button before and the device has a Pay by Bank app enabled CFI App installed, this API call invokes to the CFI App immediately (without displaying the pop-up). If there is no Pay by Bank app enabled CFI App installed on the Consumer’s device, the Pay by Bank app pop-up displays the Pay by Bank app Code automatically.

```Important In order for the library to be able to check if a Pay by Bank app enabled CFI App is installed, it is required to add LSApplicationQueriesSchemes key entry to the application Info.plist file with the string value: zapp. It specifies the common Pay by Bank app URL scheme, used by the Pay by Bank app enabled CFI Apps.```


#### How to implement the pop-up callback
1. A callback will be received when the Pay by Bank app pop-up is dismissed.
2. A sample code of how this callback should be implemented is as follows:
```python
#pragma mark - PBBAPopupViewControllerDelegate
- (void)pbbaPopupViewControllerRetryPaymentRequest:(PBBAPopupViewController *)pbbaPopupViewController
{
        // Not applicable for successful responses (only error popup)
}

- (void)pbbaPopupViewControllerDidCloseByUser:(PBBAPopupViewController *)pbbaPopupViewController
{
// Will be called when the Consumer taps on the top-right corner of the popup and dismissed it.
}
```

#### Integrate PBBA pop-up for error handling

The Pay by Bank app Merchant Button Library provides a feature to display the Pay by Bank app branded error pop-up for the payment Transaction:

```python
#import <ZappMerchantLib/PBBAAppUtils.h>
// Display PBBA error popup
[PBBAAppUtils showPBBAErrorPopup:popupPresenter errorCode:errorCode
errorTitle:errorTitle errorMessage:errorMessage delegate:popupDelegate];
```

| Parameter name | Parameter description | Parameter source |
| ------ | ------ | ------ |
| popupPresenter |    The instance of view controller which will present the PBBA pop-up. | Provided by the Merchant App. |
| errorCode | The error code to be displayed along with error message in the PBBA pop-up.| Provided by the Merchant App.|
| errorTitle | The error title to be displayed along with error message in the PBBA pop-up. | Provided by the Merchant App.|
| errorMessage    | The error message to be displayed in the PBBA pop-up.    | Provided by the Merchant App.|
| popupDelegate    | The PBBA pop-up delegate instance.| Provided by the Merchant App.|

The length of the strings displayed in the Pay by Bank app error dialog is not limited but the recommended lengths of these strings are:

1. Maximum 25 characters for the error title
2. Maximum 75 characters for the error message
3. Maximum 5 characters for the error code


#### How to implement the pop-up callback
1. A callback will be received when the Pay by Bank app pop-up is dismissed or when the PBBA Button inside the error pop-up is tapped.
2. A sample code of how this callback should be implemented is as follows:
```python
#pragma mark - PBBAPopupViewControllerDelegate
- (void)pbbaPopupViewControllerRetryPaymentRequest:(PBBAPopupViewController *)pbbaPopupViewController
{
// Will be called only when the Consumer taps on the “Pay by Bank app” button on the PBBA error popup
        // The Merchant can retry submitting the payment request
}
- (void)pbbaPopupViewControllerDidCloseByUser:(PBBAPopupViewController *)pbbaPopupViewController
{
// Will be called when the Consumer taps on the top-right corner of the popup and dismissed it.
}
```

#### Get payment status from Merchant backend
The Merchant should implement the logic for getting the status of the payment. This status change detection can be implemented in various ways and is up to the Merchant. One way to implement it is to poll the Merchant backend for status change when the Merchant App has displayed the Pay by Bank app (PBBA) pop-up and the Merchant App is active (running in the foreground). There is no need to check the payment status while the Merchant App is in the background (for example, because the focus is forwarded to the CFI App). However, the status change detection can start as soon as the PBBA pop-up is displayed because if the Consumer does not have a PBBA enabled CFI App installed, the PBBA pop-up displays the PBBA code and the payment authorisation can happen in a separate device.

#### Display payment confirmation screen
The Merchant should display their payment confirmation screen once the payment status of the Transaction is known.

### Additional consideration for the integration of an E-COMM (two device) journey

There are no additional changes required for an E-COMM journey.

```Note The Pay by Bank app Merchant Library framework automatically recognises that there is no Pay by Bank app enabled CFI App installed on the device and displays the E-COMM version of the Pay by Bank app pop-up.```

## Additional API set
### API to check if the device has Pay by Bank app enabled CFI App installed
Using this API, the Merchant App can check if the Consumer’s device has at least one PBBA enabled CFI App installed. The Operator recommends not to cache the response but call this API every time they want to check before any Pay by Bank app pop-up invocation.

```python
#import <ZappMerchantLib/PBBAAppUtils.h>
// Check if Consumer's device supports PBBA payments
if ([PBBAAppUtils isCFIAppAvailable]) {
    // The device has PBBA enabled CFI App installed
} else {
    // The device does not have PBBA enabled CFI App installed
}
```

```Note This is an optional utility API which might be used for testing purpose.```

### API to invoke the Pay by Bank app enabled CFI App
The Merchant Library provides a feature to invoke the Pay by Bank app enabled CFI App outside the Pay by Bank app pop-up. The Operator recommends not using this function unless it is completely necessary:

```python
#import <ZappMerchantLib/PBBAAppUtils.h>
// Invoke the PBBA CFI App
[PBBAAppUtils openBankingApp:secureToken];
```

This invocation happens automatically if the Merchant App calls the Pay by Bank app pop-up invocation.


|Parameter name    |Parameter description|    Parameter source|
|------    |------|------|
|secureToken    |The unique token that identifies the payment request.    |    < Consult Distributor Documentation >|

```Note This is an optional utility API which might be used for testing purpose.```


## Sample code

This section describes a frame of a simplified sample implementation of the PBBA Branded iOS Merchant Button Library for the M-COMM journey. The code displayed in black relates to the PBBA Branded iOS Button Library. The code displayed in blue is Merchant App related.

Note This is not compilable code as it assumes some of the Merchant specific codebase.

```python
#import <ZappMerchantLib/ZappMerchantLib.h>
#import "MerchantPaymentViewController.h"
@interface MerchantPaymentViewController () <PBBAButtonDelegate, PBBAPopupViewControllerDelegate>
@property (nonatomic, weak) IBOutlet PBBAButton *pbbaButton;
@property (nonatomic, strong) MerchantNetworkService networkService;
@property (nonatomic, strong) MerchantPaymentDetails paymentDetails;
@end
@implementation MerchantPaymentViewController
- (void)viewDidLoad {
[super viewDidLoad]; self.pbbaButton.delegate = self;
}
- (void)submitPayment {
// The Merchant App uses the network service to make an async HTTP request to the Merchant gateway.
// Merchant network service receives the response e.g. in JSON format, parses it to an object which is called e.g.
// Transaction and returns this object in the provided callback. An error object is returned if payment request fails. [self.networkService submitPaymentRequest:self.paymentDetails completion:^(Transaction *transaction, NSError *error) {
if (error) {
   [self didReceiveError:error];
} else {
   [self didReceiveTransaction:transaction];
}

}]; }
- (void)getPaymentStatus {
// Here the Merchant App e.g. can wait for 5 seconds not to put a heavy load on its backend
// then make a request to the Merchant gateway, load its response e.g. in JSON format, parse it to // an enum type e.g. PaymentStatus
[self.networkService getPaymentStatus:^(PaymentStatus status, NSError *error) {
        if (error) {
            [self didReceiveError:error];
        } else {
            [self didReceivePaymentStatus:status];
} }];
}

#pragma mark - Request Callbacks
- (void)didReceiveTransaction:(Transaction *transaction)
{
displayed.
// In case of standard E-Comm: this will display the PBBA Popup with the PBBA code. [PBBAAppUtils showPBBAPopup:self
}
// In case of standard M-Comm:
// If it is the very first time payment then the PBBA popup will appear.
//   If this is not the first payment then this will invoke PBBA enabled CFI App automatically without a PBBA Popup
secureToken:transaction.secureToken brn:transaction.brn
   delegate:self];

- (void)didReceiveError:(NSError *error)
{
  [PBBAAppUtils showPBBAErrorPopup:self  errorCode:nil
  errorTitle:NSLocalizedString(@"Error", nil)
  errorMessage:error.localizedDescription delegate:self];
}

- (void)didReceivePaymentStatus:(PaymentStatus status) {
if (status == PaymentStatusInProgress) { [self getPaymentStatus];
} else
// For M-Comm payment finished, display Merchant payment status page // For E-Comm payment finished, dismiss PBBA Popup
} }
#pragma mark - PBBAButtonDelegate
- (BOOL)pbbaButtonDidPress:(PBBAButton *)paymentButton {
    [self submitPayment];
    return YES; // PBBA button will start animating automatically
}
#pragma mark - PBBAPopupViewControllerDelegate
- (void)pbbaPopupViewControllerRetryPaymentRequest:(PBBAPopupViewController *)pbbaPopupViewController {
    // This method is called only when the Consumer clicks on the ‘Pay by Bank app’ button
    // on the PBBA error popup
    [self submitPayment];
}
- (void)pbbaPopupViewControllerDidCloseByUser:(PBBAPopupViewController *)pbbaPopupViewController {
// This method is called on any PBBA popup when the Consumer taps the dismiss button // on the top-right corner of the PBBA popup
self.pbbaButton.enabled = YES;
}
@end
```


## Contributing
For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
