# UdentifyNFC

UdentifyNFC is a proprietary iOS SDK developed by **Fraud.com International LTD** that enables seamless reading of e-passports and e-ID cards via NFC technology. The SDK provides a robust and secure solution for extracting biometric data, personal information, and performing authentication checks on ICAO-compliant electronic travel documents.

## Features

- ✅ **NFC Data Extraction**: Read data from e-passports and e-ID cards
- ✅ **Biometric Data**: Extract passport photos and personal information
- ✅ **Active Authentication (AA)**: Verify chip authenticity
- ✅ **Passive Authentication (PA)**: Validate document integrity
- ✅ **Fast Mode**: Optimized reading for essential data groups (DG1, DG2, DG11, DG15, SOD)
- ✅ **Progress Monitoring**: Real-time progress updates during NFC operations
- ✅ **Localization Support**: Built-in support for multiple languages
- ✅ **Comprehensive Logging**: Configurable logging levels for debugging
- ✅ **Server Integration**: Seamless data transmission to backend services

## Requirements

- iOS 13.0+
- Xcode 26.1.1
- Swift 5.0+
- Device with NFC capability (iPhone 7 or later)

## Installation

### Swift Package Manager (SPM)

UdentifyNFC can be integrated into your project using Swift Package Manager.

#### Using Xcode

1. In Xcode, open your project and navigate to **File → Add Packages...**
2. Enter the repository URL:
   ```
   https://github.com/fraudcom/UdentifyNFC
   ```
3. Select the version or branch you want to use
4. Click **Add Package**
5. Select the `UdentifyNFC` product and add it to your target

#### Using Package.swift

Add UdentifyNFC to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/fraudcom/UdentifyNFC", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["UdentifyNFC"]
    )
]
```

## Configuration

### 1. Add NFC Capability

Add the **Near Field Communication Tag Reading** capability to your target in Xcode:
- Select your project in the Navigator
- Select your app target
- Go to **Signing & Capabilities**
- Click **+ Capability**
- Add **Near Field Communication Tag Reading**

### 2. Configure project settings

In Xcode, click the project file and go to the **Targets** -> **General** section.

### 3. Modify build settings

In the **Targets** section, enter **Build Settings** and change the following settings:

* Set **Enable Bitcode** to `No`.
* Set **Skip Install** to `No`.


### 4. Update Info.plist

Add the following entries to your `Info.plist`:

```xml
<key>NFCReaderUsageDescription</key>
<string>This app needs to read NFC tags to scan passports and ID cards</string>

<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
   <string>A0000002471001</string>
</array>
```

## Usage

### Basic Implementation

```swift
import UdentifyNFC

// Ensure iOS 13.0+ availability
if #available(iOS 13.0, *) {
    // Initialize the NFC Reader
    let nfcReader = NFCReader(
        documentNumber: "123456789",
        dateOfBirth: "900101",        // Format: YYMMDD
        expiryDate: "300101",         // Format: YYMMDD
        transactionID: "unique-txn-id",
        serverURL: "https://your-server.com/api"
    )
    
    // Set delegate (optional)
    nfcReader.sessionDelegate = self
    
    // Start reading
    nfcReader.read { passport, error, progress in
        if let progress = progress {
            print("Reading progress: \(progress)%")
        }
        
        if let error = error {
            print("Error reading passport: \(error.localizedDescription)")
            return
        }
        
        if let passport = passport, progress == 100 {
            print("Successfully read passport!")
            print("Name: \(passport.firstName ?? "") \(passport.lastName ?? "")")
            print("Nationality: \(passport.nationality ?? "")")
            print("Document Number: \(passport.documentNumber ?? "")")
            
            if let photo = passport.image {
                // Use the passport photo
            }
        }
    }
}
```

### Implementing NFCReaderSessionDelegate

```swift
extension YourViewController: NFCReaderSessionDelegate {
    func nfcReaderSessionDidBegin() {
        print("NFC session started")
        // Update UI to show scanning in progress
    }
    
    func nfcReaderSessionDidEnd(with message: String?) {
        print("NFC session ended: \(message ?? "")")
        // Update UI to show completion or error
    }
}
```

### Cancel Reading

```swift
nfcReader.cancelReading {
    print("NFC reading cancelled")
}
```

### Memory Management

> [!IMPORTANT]
> `nfcReader` object needs to be set to `nil` after reading the NFC Chip to prevent memory leaks and ensure that the NFC session is properly closed.

```swift
// After successful reading or error
nfcReader.cleanUp()
nfcReader = nil
```

### Cancelling NFC Reading

If you want to set a timeout for NFC reading progress and close the NFC popup window accordingly, you can use the `cancelReading()` method:

```swift
// Cancelling NFC Reading after 5 seconds
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    self.nfcReader?.cancelReading {
        print("Cancelled automatically after 5 sec.")
    }
}
```

## Initialization Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `documentNumber` | `String` | - | Document number from MRZ (9 characters minimum) |
| `dateOfBirth` | `String` | - | Date of birth in YYMMDD format |
| `expiryDate` | `String` | - | Document expiry date in YYMMDD format |
| `transactionID` | `String` | - | Unique identifier for the transaction |
| `serverURL` | `String` | - | Base URL for backend services |
| `requestTimeout` | `Double` | `15` | Network request timeout in seconds |
| `isActiveAuthenticationEnabled` | `Bool` | `true` | Enable active authentication |
| `isPassiveAuthenticationEnabled` | `Bool` | `false` | Enable passive authentication |
| `bundle` | `Bundle` | `.main` | Resource bundle for localization |
| `tableName` | `String?` | `nil` | Localization table name |
| `isFastModeEnabled` | `Bool` | `true` | Enable fast reading mode |
| `logLevel` | `LogLevel` | `.warning` | Logging level |

## NFC Antenna Locator

**NFCLocator** helps guide the user when reading the NFC chip by informing them where to place their NFC-enabled phone. Fraud.com maintains a database of NFC antenna locations within smartphones, which is used to suggest the optimal position for the phone.

### NFCLocation Enum

```swift
public enum NFCLocation: Int {
    case unknown = 0
    case frontTop = 1
    case frontCenter = 2
    case frontBottom = 3
    case rearTop = 4
    case rearCenter = 5
    case rearBottom = 6
}
```

### Usage Example

```swift
import UIKit
import UdentifyNFC

/// A view controller that demonstrates how to use the `NFCLocator` to retrieve the NFC location.
class NFCViewController: UIViewController {
    
    /// The `NFCLocator` instance used to retrieve the NFC location from the server.
    private var nfcLocator: NFCLocator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the NFCLocator with the server URL.
        nfcLocator = NFCLocator(serverURL: "https://your-server.com/api")
        
        // Retrieve the NFC location from the server.
        nfcLocator?.locateNFC { (location, error) in
            
            if let error = error {
                // Handle the error: print an error message and set a default value.
                print("Couldn't retrieve NFC location: \(error)")
                // Set default location
                return
            }
            
            // If the location is retrieved successfully, use it to guide the user
            if let location = location {
                print("NFC location: \(location)")
                // Update UI to show optimal phone position
            }
        }
    }
}
```

## Best Practices

### General Best Practices

1. **Always validate MRZ data** before initializing the NFCReader
2. **Implement proper error handling** for all NFC operations
3. **Use fast mode** for better performance when you don't need all data groups
4. **Clean up resources** when done to prevent memory leaks
5. **Provide clear UI feedback** during NFC scanning
6. **Test on physical devices** (NFC doesn't work on simulators)
7. **Handle session lifecycle** properly with the delegate methods

### Minimizing Timeout Occurrences

To minimize NFC session timeout issues:

1. **Ensure Clear Instructions**: Provide clear visual guidance on where to position the document
2. **Use NFC Locator**: Implement the NFC Antenna Locator to help users find the optimal position
3. **Quick Start**: Begin scanning as soon as the user is ready
4. **Proper Document Alignment**: Ensure the document is properly aligned before scanning starts

## Localization

UdentifyNFC provides comprehensive localization support for NFC reading processes.

### Localization Strings

The following strings are used to display messages and directives to the user during NFC operations:

```swift
"nfc_reading_directive" = "Hold your iPhone near an NFC enabled passport.";
"nfc_reading_message" = "Reading passport data...";
"nfc_reading_progress_message" = "Reading passport data";
"nfc_reading_authentication_message" = "Authenticating with chip...";
"nfc_error_multiple_tags_message" = "Multiple Tags found. Please present only 1 tag.";
"nfc_error_tag_invalid_message" = "Tag couldn't be read.";
"nfc_error_connection_failed_message" = "NFC connection failed.";
"nfc_error_reading_failed_message" = "Problem reading the eID/ePassport. Try again.";
"nfc_error_bac_failed_message" = "BAC failed.";
"nfc_session_cancelled_by_customer" = "NFC session timed out!";
"nfc_error_tag_not_found_message" = "No NFC tag was detected.";
```

### String Descriptions

- **nfc_reading_directive**: Prompts the user to hold their iPhone near an NFC enabled passport
- **nfc_reading_message**: Displays a message that the passport is being read
- **nfc_reading_progress_message**: Indicates that the process of reading passport data is in progress
- **nfc_reading_authentication_message**: Displays a message that the NFC chip is being authenticated
- **nfc_error_multiple_tags_message**: Error message if more than one NFC chip is detected
- **nfc_error_tag_invalid_message**: Error message if the tag is invalid
- **nfc_error_connection_failed_message**: Error message if the NFC connection fails
- **nfc_error_reading_failed_message**: Error message if the eID or ePassport cannot be read
- **nfc_error_bac_failed_message**: Error message if the BAC (Basic Access Control) process fails
- **nfc_session_cancelled_by_customer**: Message displayed when the session times out (displayed after `cancelReading()` is invoked)
- **nfc_error_tag_not_found_message**: Error message when no NFC tag is detected

## Dependencies

UdentifyNFC requires the following internal dependencies:
- **UdentifyCommons**: Common utilities and shared components

## Support

For support, licensing inquiries, or additional information, please contact:

**Fraud.com International LTD**  
Email: support@fraud.com  
Website: https://fraud.com

## License

UdentifyNFC is proprietary software. Copyright © 2026 Fraud.com International Ltd. All rights reserved. See the [LICENSE](LICENSE) file for more info.


