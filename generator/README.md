# Proxy Library RPC Generator

## Overview

This script provides a possibility to auto-generate Objective-C code (header \*.h and implementation \*.m classes) based on the SDL MOBILE_API XML specification provided as a source of true.

## Requirements

The script requires **Python 3.5** pre-installed on the host system. This is the minimal **Python 3** version that has not yet reached the end-of-life (https://devguide.python.org/devcycle/#end-of-life-branches).

Note: two pyton versions can be installed on the system and to use the required third version one must use the **pip3** command instead of the commonly used **pip**.

All required libraries are listed in `requirements.txt` and should be pre-installed on the system prior to using the sript. Please use the following command to install the libraries:

```shell script
$ pip3 install -r requirements.txt
```

Please also make sure all git submodules are installed and up to date since the script uses the XML parser provided there.

```shell script
$ git submodule update --init --recursive
```

or

```shell script
$ git submodule update --recursive
```


## Usage

**Usage example**

```shell script
$ cd sdl_ios
$ python3 generator/generator.py -xml generator/rpc_spec/MOBILE_API.xml -xsd generator/rpc_spec/MOBILE_API.xsd -d output_dir
```

*Note: one may skip the first item python3 if the host system configured to run \*.py files on the Python-3 engine.*

As a result the output_dir will have all the new generated files (at the time of this article writing as many as 716 files were produced).

**Detailed usage description (keys, options)**


```
usage: generator.py [-h] [-v] [-xml SOURCE_XML] [-xsd SOURCE_XSD]
                    [-d OUTPUT_DIRECTORY] [-t [TEMPLATES_DIRECTORY]]
                    [-r REGEX_PATTERN] [--verbose] [-e] [-s] [-m] [-y] [-n]

Proxy Library RPC Generator

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         print the version and exit
  -xml SOURCE_XML, --source-xml SOURCE_XML, --input-file SOURCE_XML
                        should point to MOBILE_API.xml
  -xsd SOURCE_XSD, --source-xsd SOURCE_XSD
  -d OUTPUT_DIRECTORY, --output-directory OUTPUT_DIRECTORY
                        define the place where the generated output should be
                        placed
  -t [TEMPLATES_DIRECTORY], --templates-directory [TEMPLATES_DIRECTORY]
                        path to directory with templates
  -r REGEX_PATTERN, --regex-pattern REGEX_PATTERN
                        only elements matched with defined regex pattern will
                        be parsed and generated
  --verbose             display additional details like logs etc
  -e, --enums           only specified elements will be generated, if present
  -s, --structs         only specified elements will be generated, if present
  -m, -f, --functions   only specified elements will be generated, if present
  -y, --overwrite       force overwriting of existing files in output
                        directory, ignore confirmation message
  -n, --skip            skip overwriting of existing files in output
                        directory, ignore confirmation message
```

### How to use the generated classes

Since all RPC classes used in **SmartDeviceLink iOS** library were created manually due to historical reasons the generated files might and will differ from the original ones. The code generator takes all efforts possible to produce source code as close to the original as possible and it already has maps (dictionaries) to rename classes, data structures that do not follow the naming rules though it is not quite possible since the source of true is the XML file and anything that goes beyond it is hard if possible at all to handle. To incorporate the generated files into the project one must use a diff tool (Meld, FileMerge, you name it) and compare the 2 sets of RPC files and check what changed and which changes should go upstream. The last but no least chances are there appear new generated files that are not present in the project. If such a case one must add those files to Xcode project manually and place them in proper groups sorting the files by their kind. Note: the groups are just virtual folders and due to historical reasons the ones do not map to file system folders so phisically all files go to the root folder and when they get added to the project they should go to the following folders:
  * Enums
  * Structs
  * Notification
  * Requests
  * Responses

Due to the explosion of complexity and code that is involved with mapping every exception that has ever been made in the iOS project compared to the RPC spec, the decision was made that the generator should not pursue those mappings. This has several implications:

  * The generator will not override the existing RPCs. All newly created structs, enums, requests, responses, and notifications will be generated, but new parameters to existing RPCs will have to be manually handled. The script's `--skip` command line switch will be used.
  * Existing unit tests cannot be used to verify the output.

The idea is that a future major version could involve a switch-over to using all generated code instead of the current code. It is not perfect for the current version but it is helpful for adding new RPCs.
Any major version change cannot be done that would be involved with overwriting existing RPC classes and to map out all the differences would be a huge time and complexity-sink that the PM and PR author agreed was feasible but unmaintainable and undesirable.

#  Objetive-C transformation rules

## Overview
These are the general transformation rules for SDL RPC classes Objective-C Library. The base classes description already included in the library is not provided here for more one may want to view the source code.

## Output Directory Structure and Package definitions

The script creates corresponding RPC classes of `<enum>`, `<struct>` and `<function>` elements following the `MOBILE_API.xml` rules. According to existing structure of SmartDeviceLink library the output directory will contain the following files (plain structure, no subfolders). For enum, struct, function future naming, generally it should be named 

```SDL<Enum Name><Value>```

 in camel case.


**Requests:**

  * SDLxxx.h
  * SDLxxx.m
  
**Responses:**

  * SDLxxxResponse.h
  * SDLxxxResponse.m

*Note: as an exception from rules this kind has the suffix 'Response'*
 
**Structures:**

  * SDLxxx.h
  * SDLxxx.m

**Enums:**

  * SDLxxx.h
  * SDLxxx.m

**Notifications:**

  * SDLxxx.h
  * SDLxxx.m

Where the **xxx** is the correspondent item name.


## The License Header

All files should begin with the license information.

```
/*
 * Copyright (c) 2017 - [year], SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
```
Where `[year]` in the copyright line is the current (?) year.
*Note: for simplisity sake the header removed from Objective-C code snippets in the following sections of this document*


### General rules for Objective-C classes
1. Default initializer in every class 
```objc
    - (instancetype)init {
        if ((self = [super initWithName:SDLRPCFunctionNameRegisterAppInterface])) {
        }
        return self;
    }
```
*Pease note the required double brackets in the if statement*

2. Initializer for mandatory params if there is/are any in XML (skipped if no <mandatory = true> params)

3. Initializer for all params if there is/are any which is not mandatory in XML (skipped if no <mandatory = false> params)

## Scalars.
There are 4 type of scalar values declared in the SDL lib.  These are:
1. **SDLInt** - A declaration that this NSNumber contains an NSInteger.
0. **SDLUInt** - A declaration that this NSNumber contains an NSUInteger.
0. **SDLBool** - A declaration that this NSNumber contains a BOOL.
0. **SDLFloat** - A declaration that this NSNumber contains a float.
*Note: the ones declared as empty protocols and NSNumber conforms to them.*
```objc
@interface NSNumber (NumberType) <SDLInt, SDLUInt, SDLBool, SDLFloat>
```
Usage example:
```objc
@property (strong, nonatomic) NSNumber<SDLInt> *touchEventId;
```
or an array:
```objc
@property (strong, nonatomic) NSArray<NSNumber<SDLInt> *> *timeStamp;
```
*Note: the 4 scalar values implemented as empty protocols and 'extend' the* **NSNumber** *class.*

## Enums
So called enums in **sdl\_ios** implemented as strings (NSString) typedefed with a proper enum type. One may notice it is not real enums but NSString objects though in SWIFT they must become real enums.

*Example:*

```objc
typedef NSString* SDLEnum SDL_SWIFT_ENUM;
```

*Note: This new defined type has already had an asterisk at the end so anything that inherits from SDLEnum needs no asterisk.*

```objc
typedef SDLEnum SDLTouchType SDL_SWIFT_ENUM;
```

*Note: The compiler considers SDLTouchType as NSString**

And here is a concrete 'enum' item

```objc
extern SDLTouchType const SDLTouchTypeBegin;
```

If an item is deprecated then it will be declared as such:

```objc
extern SDLTouchType const SDLTouchTypeBegin __deprecated;
```

or even:

```objc
extern SDLTouchType const SDLTouchTypeBegin __deprecated_msg(("this item is deprecated once and for all, please use SDLTouchTypeNewType instead"));
```


Each Enum class is stored in two files (header \*.h and implementation \*.m)  and the filename and the class name should be composed based on the value from the `"name"` attribute of `<enum>`.

Example:

```
<enum name="ImageType" .../>
./SDLImageType.h
./SDLImageType.m
```

Each Enum class should include the enum definition, see for example the AmbientLightStatus enum:

```objc
#import "SDLEnum.h"
typedef SDLEnum SDLAmbientLightStatus SDL_SWIFT_ENUM;
```

Take for an instance the enum class KeypressMode
 
```xml
<enum name="KeypressMode" since="3.0">
    <description>Enumeration listing possible keyboard events.</description>
    <element name="SINGLE_KEYPRESS">
        <description>Each keypress is individually sent as the user presses the keyboard keys.</description>
    </element>
    <element name="QUEUE_KEYPRESSES">
        <description>The keypresses are queued and a string is eventually sent once the user chooses to submit their entry.</description>
    </element>
    <element name="RESEND_CURRENT_ENTRY">
        <description>The keypresses are queue and a string is sent each time the user presses a keyboard key; the string contains the entire current entry.</description>
    </element>
</enum>
```

In the following example 

```objc
extern SDLKeypressMode const SDLKeypressModeSingleKeypress;
```

The **SDLKeypressModeSingleKeypress** enum is seen by the compiler as:

```objc
extern NSString* const SDLKeypressModeSingleKeypress;
```

and **SDLKeypressModeSingleKeypress** itself must be implemented in the correspondent SDLKeypressMode.m file as a string:

```objc
SDLKeypressMode const SDLKeypressModeSingleKeypress = @"SINGLE_KEYPRESS";
```

## Structures

Structures in **sdl_ios**  implemented as classes derived from the parent class SDLRPCStruct with all parameters implemented as "@property". Let us take for an instance the **DeviceInfo** structure. In the XML it is declared as following:

```xml
<struct name="DeviceInfo" since="3.0">
        <description>Various information about connecting device.</description>        
        <param name="hardware" type="String"  minlength="0" maxlength="500" mandatory="false">
            <description>Device model</description>
        </param>
        <param name="firmwareRev" type="String" minlength="0" maxlength="500" mandatory="false">
            <description>Device firmware revision</description>
        </param>
        <param name="os" type="String" minlength="0" maxlength="500" mandatory="false">
            <description>Device OS</description>
        </param>
        <param name="osVersion" type="String" minlength="0" maxlength="500" mandatory="false">
            <description>Device OS version</description>
        </param>
        <param name="carrier" type="String" minlength="0" maxlength="500" mandatory="false">
            <description>Device mobile carrier (if applicable)</description>
        </param>
        <param name="maxNumberRFCOMMPorts" type="Integer" minvalue="0" maxvalue="100" mandatory="false">
            <description>Omitted if connected not via BT.</description>
        </param>        
 </struct>
 ```
 
 *Please note that all params declared as mandatory="false" and there is one init method with all the params in the generated file. The method* ```+ (instancetype)currentDevice;``` *comes from the old manually made implementation*
 *All method and property descriptions generated from the xml descriptions*

 *Note: the file begins with the* **NS_ASSUME_NONNULL_BEGIN** *macro which makes all properties / parameters mandatory. If a parameter is not mandatory then the modifier* **nullable** *will be used*

```objc
//  SDLDeviceInfo.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Various information about connecting device.
 *
 * @since SDL 3.0.0
 */
@interface SDLDeviceInfo : SDLRPCStruct

/// Convenience init. Object will contain all information about the connected device automatically.
///
/// @return An SDLDeviceInfo object
+ (instancetype)currentDevice;

/**
 * @param hardware
 * @param firmwareRev
 * @param os
 * @param osVersion
 * @param carrier
 * @param @(maxNumberRFCOMMPorts)
 * @return A SDLDeviceInfo object
 */
- (instancetype)initWithHardware:(nullable NSString *)hardware firmwareRev:(nullable NSString *)firmwareRev os:(nullable NSString *)os osVersion:(nullable NSString *)osVersion carrier:(nullable NSString *)carrier maxNumberRFCOMMPorts:(UInt8)maxNumberRFCOMMPorts;

/**
 * Device model
 * {"default_value": null, "max_length": 500, "min_length": 0}
 *
 * Optional, NSString *
 */
@property (nullable, strong, nonatomic) NSString *hardware;

/**
 * Device firmware revision
 * {"default_value": null, "max_length": 500, "min_length": 0}
 *
 * Optional, NSString *
 */
@property (nullable, strong, nonatomic) NSString *firmwareRev;

/**
 * Device OS
 * {"default_value": null, "max_length": 500, "min_length": 0}
 *
 * Optional, NSString *
 */
@property (nullable, strong, nonatomic) NSString *os;

/**
 * Device OS version
 * {"default_value": null, "max_length": 500, "min_length": 0}
 *
 * Optional, NSString *
 */
@property (nullable, strong, nonatomic) NSString *osVersion;

/**
 * Device mobile carrier (if applicable)
 * {"default_value": null, "max_length": 500, "min_length": 0}
 *
 * Optional, NSString *
 */
@property (nullable, strong, nonatomic) NSString *carrier;

/**
 * Omitted if connected not via BT.
 * {"default_value": null, "max_value": 100, "min_value": 0}
 *
 * Optional, UInt8
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *maxNumberRFCOMMPorts;

@end

NS_ASSUME_NONNULL_END
```

The implementation **SDLDeviceInfo.m** file:

```objc
//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeviceInfo


+ (instancetype)currentDevice {
    static SDLDeviceInfo *deviceInfo = nil;
    if (deviceInfo == nil) {
        deviceInfo = [[SDLDeviceInfo alloc] init];
        deviceInfo.hardware = [UIDevice currentDevice].model;
        deviceInfo.os = [UIDevice currentDevice].systemName;
        deviceInfo.osVersion = [UIDevice currentDevice].systemVersion;
        CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = netinfo.subscriberCellularProvider;
        NSString *carrierName = carrier.carrierName;
        deviceInfo.carrier = carrierName;
    }
    return deviceInfo;
}

- (instancetype)initWithHardware:(nullable NSString *)hardware firmwareRev:(nullable NSString *)firmwareRev os:(nullable NSString *)os osVersion:(nullable NSString *)osVersion carrier:(nullable NSString *)carrier maxNumberRFCOMMPorts:(UInt8)maxNumberRFCOMMPorts {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.hardware = hardware;
    self.firmwareRev = firmwareRev;
    self.os = os;
    self.osVersion = osVersion;
    self.carrier = carrier;
    self.maxNumberRFCOMMPorts = @(maxNumberRFCOMMPorts);
    return self;
}

- (void)setHardware:(nullable NSString *)hardware {
    [self.store sdl_setObject:hardware forName:SDLRPCParameterNameHardware];
}

- (nullable NSString *)hardware {
    return [self.store sdl_objectForName:SDLRPCParameterNameHardware ofClass:NSString.class error:nil];
}

- (void)setFirmwareRev:(nullable NSString *)firmwareRev {
    [self.store sdl_setObject:firmwareRev forName:SDLRPCParameterNameFirmwareRevision];
}

- (nullable NSString *)firmwareRev {
    return [self.store sdl_objectForName:SDLRPCParameterNameFirmwareRevision ofClass:NSString.class error:nil];
}

- (void)setOs:(nullable NSString *)os {
    [self.store sdl_setObject:os forName:SDLRPCParameterNameOS];
}

- (nullable NSString *)os {
    return [self.store sdl_objectForName:SDLRPCParameterNameOS ofClass:NSString.class error:nil];
}

- (void)setOsVersion:(nullable NSString *)osVersion {
    [self.store sdl_setObject:osVersion forName:SDLRPCParameterNameOSVersion];
}

- (nullable NSString *)osVersion {
    return [self.store sdl_objectForName:SDLRPCParameterNameOSVersion ofClass:NSString.class error:nil];
}

- (void)setCarrier:(nullable NSString *)carrier {
    [self.store sdl_setObject:carrier forName:SDLRPCParameterNameCarrier];
}

- (nullable NSString *)carrier {
    return [self.store sdl_objectForName:SDLRPCParameterNameCarrier ofClass:NSString.class error:nil];
}

- (void)setMaxNumberRFCOMMPorts:(nullable NSNumber<SDLUInt> *)maxNumberRFCOMMPorts {
    [self.store sdl_setObject:maxNumberRFCOMMPorts forName:SDLRPCParameterNameMaxNumberRFCOMMPorts];
}

- (nullable NSNumber<SDLUInt> *)maxNumberRFCOMMPorts {
    return [self.store sdl_objectForName:SDLRPCParameterNameMaxNumberRFCOMMPorts ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
```
## Functions

Functions in iOS implemented as 3 different classes grouped by its kind, all the 3 extend the common parent class **SDLRPCMessage**
```objc
// This is the parent class for all the 3 function kinds
SDLRPCMessage : SDLRPCStruct <NSCopying> : NSObject <NSCopying>

SDLRPCNotification : SDLRPCMessage  /// An RPC sent from the head unit to the app about some data change, such as a button was pressed
SDLRPCRequest : SDLRPCMessage   /// Superclass of RPC requests
SDLRPCResponse : SDLRPCMessage  /// Superclass of RPC responses
```
*Note: for some reason SDLRPCMessage conforms to NSCopying protocol twice.*

First of all there is the **FunctionID** class generated though it is not declared in the XML. This class maps all function IDs that are integers to function names as strings.

1. Uses of the `"name"` attribute should be normalized by the removal of the ID suffix, e.g. `RegisterAppInterfaceID -> RegisterAppInterface`. 
  
0. The constant name should be camel case formatted.
  
0. The constant has 2 fields the first is the `int` value of the `"value"` attribute and the second is the `String` value of normalized `"name"` attribute.

Internally it uses another file that lists all the function names **SDLRPCFunctionNames**

```objc
//  SDLFunctionID.h

#import <Foundation/Foundation.h>
#import "NSNumber+NumberType.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

/// A function ID for an SDL RPC
@interface SDLFunctionID : NSObject

/// The shared object for pulling function id information
+ (instancetype)sharedInstance;

/// Gets the function name for a given SDL RPC function ID
///
/// @param functionID A function ID
/// @returns An SDLRPCFunctionName
- (nullable SDLRPCFunctionName)functionNameForId:(UInt32)functionID;

/// Gets the function ID for a given SDL RPC function name
///
/// @param functionName The RPC function name
- (nullable NSNumber<SDLInt> *)functionIdForName:(SDLRPCFunctionName)functionName;

@end

NS_ASSUME_NONNULL_END
```

Each <function> from MOBILE_API.XML is declared in SDLRPCFunctionNames.h and SDLRPCFunctionNames.m files. It exports function names as strings.

```objc
SDLRPCFunctionNames.h
#import "SDLEnum.h"
/**
* All RPC request / response / notification names
*/
typedef SDLEnum SDLRPCFunctionName SDL_SWIFT_ENUM;

/// Function name for an AddCommand RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameAddCommand;

/// Function name for an AddSubMenu RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameAddSubMenu;

. . . and so on
```

And the implementation file SDLRPCFunctionNames.m :

```objc
//
//  SDLRPCFunctionNames.m
//  SmartDeviceLink
//

#import "SDLRPCFunctionNames.h"

SDLRPCFunctionName const SDLRPCFunctionNameAddCommand = @"AddCommand";
SDLRPCFunctionName const SDLRPCFunctionNameAddSubMenu = @"AddSubMenu";

. . . and so on
```


### Request Functions (SDLRPCRequest)

#### Without parameters

The templates from the table below can be used as a basic for each Request class which can be generated from MOBILE_API.XML
Two different file types with (".h" amd ".m" extensions) need to be created for each function in the XML.

```xml
<function name="ListFiles" functionID="ListFilesID" messagetype="request" since="3.0">
    <description>
         Requests the current list of resident filenames for the registered app.
         Not supported on first generation SDL enabled vehicles.
    </description>
</function>
```

Declaration file (.h)

```objc
//  SDLListFiles.h
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Requests the current list of resident filenames for the registered app. Not supported on first generation SDL
 * enabled vehicles.
 *
 * @since SDL 3.0.0
 */
@interface SDLListFiles : SDLRPCRequest

@end

NS_ASSUME_NONNULL_END
```

Implementation file (.m)

```objc
//  SDLListFiles.m

#import "SDLListFiles.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLListFiles

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if ((self = [super initWithName:SDLRPCFunctionNameListFiles])) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
```






##### Function with simple params

This section depicts all functions which include one or a few parameters of the following types (integer|decimal|boolean|string). Such parameters are considered as simple.

```xml
    <function name="GetCloudAppProperties" functionID="GetCloudAppPropertiesID" messagetype="request" since="5.1">
        <description>
            RPC used to get the current properties of a cloud application
        </description> 
        <param name="appID" type="String" maxlength="100" mandatory="true"></param>
    </function>
```

### Request Functions (SDLRPCRequest)

The parent class is **SDLRPCRequest**

```objc
//  SDLGetCloudAppProperties.h
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * RPC used to get the current properties of a cloud application
 *
 * @since SDL 5.1.0
 */
@interface SDLGetCloudAppProperties : SDLRPCRequest

/**
 * @param appID
 * @return A SDLGetCloudAppProperties object
 */
- (instancetype)initWithAppID:(NSString *)appID;

/**
 * {"default_value": null, "max_length": 100, "min_length": 1}
 *
 * Required, NSString *
 */
@property (strong, nonatomic) NSString *appID;

@end

NS_ASSUME_NONNULL_END
```


```objc
//  SDLGetCloudAppProperties.m
//

#import "SDLGetCloudAppProperties.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetCloudAppProperties

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if ((self = [super initWithName:SDLRPCFunctionNameGetCloudAppProperties])) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setAppID:(NSString *)appID {
    [self.parameters sdl_setObject:appID forName:SDLRPCParameterNameAppId];
}

- (NSString *)appID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppId ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
```

### Response Functions (SDLRPCResponse)

The parent class is **SDLRPCResponse**

Simple response example **AddCommand**, with no arguments:

```xml
    <function name="AddCommand" functionID="AddCommandID" messagetype="response" since="1.0">
        
        <param name="success" type="Boolean" platform="documentation" mandatory="true">
            <description> true if successful; false, if failed </description>
        </param>
        
        <param name="resultCode" type="Result" platform="documentation" mandatory="true">
            <description>See Result</description>
            <element name="SUCCESS"/>
            <element name="INVALID_DATA"/>
            <element name="OUT_OF_MEMORY"/>
            <element name="TOO_MANY_PENDING_REQUESTS"/>
            <element name="APPLICATION_NOT_REGISTERED"/>
            <element name="GENERIC_ERROR"/>
            <element name="REJECTED"/>
            <element name="INVALID_ID"/>
            <element name="DUPLICATE_NAME"/>
            <element name="UNSUPPORTED_RESOURCE"/>
            <element name="DISALLOWED"/>
            <element name="WARNINGS"/>
        </param>
        
        <param name="info" type="String" maxlength="1000" mandatory="false" platform="documentation">
            <description>Provides additional human readable info regarding the result.</description>
        </param>
        
    </function>
```

```objc
//  SDLAddCommandResponse.h
//

#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @since SDL 1.0.0
 */
@interface SDLAddCommandResponse : SDLRPCResponse

@end

NS_ASSUME_NONNULL_END
```

```objc
//  SDLAddCommandResponse.m
//

#import "SDLAddCommandResponse.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAddCommandResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if ((self = [super initWithName:SDLRPCFunctionNameAddCommand])) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
```

As one may notice this class does not implement too much since the main logic is already implemented in its parent class:

```objc
//  SDLRPCResponse.h
//

#import "SDLRPCMessage.h"
#import "SDLResult.h"

NS_ASSUME_NONNULL_BEGIN

/// Superclass of RPC responses
@interface SDLRPCResponse : SDLRPCMessage

/**
 *  The correlation id of the corresponding SDLRPCRequest.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *correlationID;

/**
 *  Whether or not the SDLRPCRequest was successful.
 */
@property (strong, nonatomic) NSNumber<SDLBool> *success;

/**
 *  The result of the SDLRPCRequest. If the request failed, the result code contains the failure reason.
 */
@property (strong, nonatomic) SDLResult resultCode;

/**
 *  More detailed success or error message.
 */
@property (nullable, strong, nonatomic) NSString *info;

@end

NS_ASSUME_NONNULL_END
```

#### Response class with extra argument example (Alert Response):

```xml
<function name="Alert" functionID="AlertID" messagetype="response" since="1.0">
        
        <param name="success" type="Boolean" platform="documentation" mandatory="true">
            <description> true if successful; false, if failed </description>
        </param>
        
        <param name="resultCode" type="Result" platform="documentation" mandatory="true">
            <description>See Result</description>
            <element name="SUCCESS"/>
            <element name="INVALID_DATA"/>
            <element name="OUT_OF_MEMORY"/>
            <element name="TOO_MANY_PENDING_REQUESTS"/>
            <element name="APPLICATION_NOT_REGISTERED"/>
            <element name="GENERIC_ERROR"/>
            <element name="REJECTED"/>
            <element name="ABORTED"/>
            <element name="DISALLOWED"/>
            <element name="USER_DISALLOWED"/>
            <element name="UNSUPPORTED_RESOURCE"/>
            <element name="WARNINGS"/>
        </param>
        
        <param name="info" type="String" maxlength="1000" mandatory="false" platform="documentation">
            <description>Provides additional human readable info regarding the result.</description>
        </param>
        
        <param name="tryAgainTime" type="Integer" minvalue="0" maxvalue="2000000000" mandatory="false" since="2.0">
            <description>
                Amount of time (in seconds) that an app must wait before resending an alert.
                If provided, another system event or overlay currently has a higher priority than this alert.
                An app must not send an alert without waiting at least the amount of time dictated.
            </description>
        </param>
        
    </function>
```

As we can see it in the XML it requites an additional param **tryAgainTime** which is declared and implemented in the **SDLAlertResponse** class as follows:

```objc
//  SDLAlertResponse.h
//

#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @since SDL 1.0.0
 */
@interface SDLAlertResponse : SDLRPCResponse

/**
 * @param @(tryAgainTime)
 * @return A SDLAlertResponse object
 */
- (instancetype)initWithTryAgainTime:(UInt32)tryAgainTime;

/**
 * Amount of time (in seconds) that an app must wait before resending an alert. If provided, another system event or
 * overlay currently has a higher priority than this alert. An app must not send an alert without waiting at least
 * the amount of time dictated.
 * {"default_value": null, "max_value": 2000000000, "min_value": 0}
 *
 * @since SDL 2.0.0
 *
 * Optional, UInt32
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *tryAgainTime;

@end

NS_ASSUME_NONNULL_END
```

```objc
//  SDLAlertResponse.m
//


#import "SDLAlertResponse.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if ((self = [super initWithName:SDLRPCFunctionNameAlert])) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setTryAgainTime:(nullable NSNumber<SDLUInt> *)tryAgainTime {
    [self.parameters sdl_setObject:tryAgainTime forName:SDLRPCParameterNameTryAgainTime];
}

- (nullable NSNumber<SDLUInt> *)tryAgainTime {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTryAgainTime ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
```

### Notification Functions (SDLRPCNotification)

The parent class is **SDLRPCNotification**


Let us take for an instance the class **SDLOnAudioPassThru**. It is declared in the XML as follows. It does not look as much as anything and so its implementation.

```xml
<function name="OnAudioPassThru" functionID="OnAudioPassThruID" messagetype="notification" since="2.0">
        <description>Binary data is in binary part of hybrid msg</description>
    </function>
```

The corresponding Objective-C class **SDLOnAudioPassThru** looks as following.

```objc
//  SDLOnAudioPassThru.h

#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Binary data is in binary part of hybrid msg
 *
 * @since SDL 2.0.0
 */
@interface SDLOnAudioPassThru : SDLRPCNotification

@end

NS_ASSUME_NONNULL_END
```

```objc
//  SDLOnAudioPassThru.m

#import "SDLOnAudioPassThru.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnAudioPassThru

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if ((self = [super initWithName:SDLRPCFunctionNameOnAudioPassThru])) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
```


Another example is the class **SDLOnAppInterfaceUnregistered**. It is declared in the XML as follows.

```xml
<function name="OnAppInterfaceUnregistered" functionID="OnAppInterfaceUnregisteredID" messagetype="notification" since="1.0">
        <param name="reason" type="AppInterfaceUnregisteredReason" mandatory="true">
            <description>See AppInterfaceUnregisteredReason</description>
        </param>
    </function>
```

The corresponding Objective-C class **SDLOnAppInterfaceUnregistered** looks as following.

```objc
//  SDLOnAppInterfaceUnregistered.h

#import "SDLRPCNotification.h"

@class SDLAppInterfaceUnregisteredReason;

NS_ASSUME_NONNULL_BEGIN

/**
 * @since SDL 1.0.0
 */
@interface SDLOnAppInterfaceUnregistered : SDLRPCNotification

/**
 * @param reason - @(reason)
 * @return A SDLOnAppInterfaceUnregistered object
 */
- (instancetype)initWithReason:(SDLAppInterfaceUnregisteredReason)reason;

/**
 * See AppInterfaceUnregisteredReason
 *
 * Required, SDLAppInterfaceUnregisteredReason 
 */
@property (strong, nonatomic) SDLAppInterfaceUnregisteredReason reason;

@end

NS_ASSUME_NONNULL_END
```

*Note: though the `SDLAppInterfaceUnregisteredReason reason` declared as a property but implemented as custom getter and setter*

```objc
//  SDLOnAppInterfaceUnregistered.m

#import "SDLOnAppInterfaceUnregistered.h"
#import "NSMutableDictionary+Store.h"
#import "SDLAppInterfaceUnregisteredReason.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnAppInterfaceUnregistered

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if ((self = [super initWithName:SDLRPCFunctionNameOnAppInterfaceUnregistered])) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithReason:(SDLAppInterfaceUnregisteredReason)reason {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.reason = @(reason);
    return self;
}

- (void)setReason:(SDLAppInterfaceUnregisteredReason)reason {
    [self.parameters sdl_setObject:reason forName:SDLRPCParameterNameReason];
}

- (SDLAppInterfaceUnregisteredReason)reason {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameReason error:&error];
}

@end

NS_ASSUME_NONNULL_END
```

# Custom mapping

There are cases named `edge cases` when it is not possible to get the required info from XML or some manual additions are required in generated classes. For that purpose the generator includes the custom mapping file `mapping.json` that allows to add required customizations.

## Structure of `mapping.json`

The customization script contains the JSON object. Below is the schema:

Enums:
```json5
{
  ["enums"]: {
    [enum_name]: {
      "template": [true|custom_template_name],
      "name": [custom_enum_namee],
      "description": [custom_description_string],
      "deprecated": [custom_deprecated_description_string],
      "-params": [element_to_delete, param_to_delete, ...],
      "params_title": false
      [element_name]: {
        "origin": [custom_element_name], 
        "description": [custom_description_string],
        "since": [custom_since_version_string], 
        "value": [custom_value]
      }
    }
  }
}
```

Structs and Functions:
```json5
{
  ["structs"|"functions"]: {
    [struct_name|function_name]: {
      "template": [true|custom_template_name],
      "name": [custom_struct_name|custom_function_name],
      "description": [custom_description_string],
      "deprecated": [custom_deprecated_description_string],
      "sort_constructor": true,
      "-params": [element_to_delete, param_to_delete, ...],
      [param_name|member_name]: {
        "origin": [custom_param_name|custom_member_name], 
        "constructor_argument": [custom_constructor_argument_name_string],
        "constructor_prefix": [custom_constructor_parameter_name_string],
        "method_suffix": [custom_forName:SDLRPCParameterName_method_suffix_name_string],
        "deprecated": [custom_deprecated_description_string],
        "mandatory": [true|false], 
        "since": [custom_since_version_string], 
        "of_class": [custom_"ofClass:{{of_class}}"_string],
        "type_native": [custom_type_used_in_constructor_string],
        "type_sdl": [custom_type_used_in_methods_string], 
        "modifier": [assign|copy|strong|weak],
        "for_name": [custom_"_sdl_{{for_name}}"_name_string],
        "description": [custom_description_string],
        "constructor_argument_override": [custom_constructor_argument_string],
      }
    }
  }
}
```

Root keys in the structure are `"enums"`, `"structs"` and `"functions"`. 
On the next level expected `name`, `template`, `description`, `deprecated`, `sort_constructor`, `-params`, `params_title` or corresponding name of required `<enum>`, `<struct>`, `<function>`.
Then the next level, is set of properties which present in each corresponding structure.
In case when corresponding structure exist not required to list all properties.

The mapping object provide the possibility to create brand new `<enum>`, `<struct>` or `<function>`, in this case all corresponding properties should be provided.

## "template"

It is possible to create custom template for any corresponding structure (`<enum>`, `<struct>`, `<function>`).

As template engine used jinja, which has own language, documentation - https://jinja.palletsprojects.com/en/2.11.x/ 
like it was done for `sdl_ios/generator/templates/enums/FunctionID.*`, otherwise you can extend existing template and add required functionality.

There are following block's in default template:
* {% block imports %}
* {% block constructors %}
* {% block methods %}

You can extend it by adding your custom code and call `{{super()}}` to add code from parent template, example:
```jinja
{%- block imports %}
yout code
{{super()}}
{%- endblock -%}
```

To enable custom template feature add following into `sdl_ios/generator/mapping.json`:
```json
{
  "functions": {
    "PutFile": {
        "template": true
      }
    }
}
```

Create custom template - `sdl_ios/generator/templates/functions/PutFile.h`:
```jinja
{% extends 'functions/template.h' %}
{%- block imports %}
#import <Foundation/Foundation.h>
{{super()}}
{%- endblock -%}
{%- block constructors -%}
{{super()}}
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length bulkData:(NSData *)bulkData;
{% endblock -%}
{%- block methods %}
@property (nullable, copy, nonatomic) SDLRPCCommandNotificationHandler handler;
{{super()}}
{%- endblock -%}
```

As a result the generated file will look like the following - `sdl_ios/SmartDeviceLink/SDLPutFile.h`:
```objc
...
#import <Foundation/Foundation.h>
...
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length bulkData:(NSData *)bulkData;
...
@property (nullable, copy, nonatomic) SDLRPCCommandNotificationHandler handler;
...
```

Create custom template - `sdl_ios/generator/templates/functions/PutFile.m`:
```jinja
{% extends 'functions/template.h' %}
{%- block imports -%}
{{super()}}

static NSString *const SDLBundleShortVersionStringKey = @"CFBundleShortVersionString";
static NSString *const SDLBundleAppNameKey = @"CFBundleName";
{%- endblock -%}
{%- block constructors -%}
{{super()}}
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length bulkData:(NSData *)bulkData {

    self = [self initWithFileName:fileName fileType:fileType persistentFile:persistentFile systemFile:systemFile offset:offset length:length crc:[self.class sdl_getCRC32ChecksumForBulkData:bulkData]];
    if (!self) {
        return nil;
    }

    self.bulkData = bulkData;

    return self;
}

#pragma mark - Getters and Setters
{% endblock -%}
{%- block methods %}
#pragma mark - Getters / Setters
{{super()}}
-(id)copyWithZone:(nullable NSZone *)zone {
    SDLAddCommand *newCommand = [super copyWithZone:zone];
    newCommand->_handler = self.handler;

    return newCommand;
}
{% endblock -%}
```

As result generated file will look like the following - `sdl_ios/SmartDeviceLink/SDLPutFile.m`:
```objc
...
static NSString *const SDLBundleShortVersionStringKey = @"CFBundleShortVersionString";
static NSString *const SDLBundleAppNameKey = @"CFBundleName";
...
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length bulkData:(NSData *)bulkData {

    self = [self initWithFileName:fileName fileType:fileType persistentFile:persistentFile systemFile:systemFile offset:offset length:length crc:[self.class sdl_getCRC32ChecksumForBulkData:bulkData]];
    if (!self) {
        return nil;
    }

    self.bulkData = bulkData;

    return self;
}

#pragma mark - Getters and Setters
...
-(id)copyWithZone:(nullable NSZone *)zone {
    SDLAddCommand *newCommand = [super copyWithZone:zone];
    newCommand->_handler = self.handler;

    return newCommand;
}
...
```

## "name"

Change name of original structure.

Notice: Name of class and name of file is the the same, so overriding of "name" property aso change the name of target file.

Example:
```json
{
  "enums": {
    "HmiZoneCapabilities": {
        "name": "SDLHMIZoneCapabilities"
      }
    }
}
```

`sdl_ios/SmartDeviceLink/SDLHMIZoneCapabilities.m`:
```objc
...
#import "SDLHMIZoneCapabilities.h"
...
SDLHMIZoneCapabilities const SDLHMIZoneCapabilitiesFront = @"FRONT";
...
```

`sdl_ios/SmartDeviceLink/SDLHMIZoneCapabilities.h`:
```objc
...
typedef SDLEnum SDLHMIZoneCapabilities SDL_SWIFT_ENUM;
...
extern SDLHMIZoneCapabilities const SDLHMIZoneCapabilitiesFront;
...
```

## "description"

```json
{
  "functions": {
    "RegisterAppInterfaceResponse": {
        "description": "long custom description"
      }
    }
}
```

As a result the generated file will look like the following - `sdl_ios/SmartDeviceLink/SDLRegisterAppInterfaceResponse.h`:
```objc
...
/**
 * long custom description
 */
@interface SDLRegisterAppInterfaceResponse : SDLRPCResponse
...
```

## "deprecated"

If particular structure marked as deprecated is source xml, e.g.:
```xml
<enum name="SupportedSeat" deprecated="true" since="6.0">
```

By default the generated file will look like the following:
```objc
...
/**
 * @deprecated
 */
typedef SDLEnum SDLSupportedSeat SDL_SWIFT_ENUM __deprecated;
...
```

But you are able to provide description for deprecated structure:
```json
{
  "enums": {
    "SupportedSeat": {
        "deprecated": "custom deprecated description"
      }
    }
}
```
As a result the generated file will look like the following - `sdl_ios/SmartDeviceLink/SDLSupportedSeat.h`:
```objc
...
/**
 * @deprecated
 */
typedef SDLEnum SDLSupportedSeat SDL_SWIFT_ENUM __deprecated_msg("custom deprecated description");
...
```

In case if particular structure wasn't marked as deprecated is source xml and you added "deprecated" for it into "mapping.json", appropriate structure will be marked as deprecated

## "sort_constructor"

All "elements|members|params" from particular structure will be transformed into target code in same sequence in which it present in source xml.
By default the appropriate initiator (constructor) will be created from all "elements|members|params" with same sequence in which it present in source xml.

To sort all "elements|members|params" by alphabetical order and then creating appropriate initiator (constructor) use following mapping parameter:

```json
{
  "functions": {
    "RegisterAppInterfaceResponse": {
        "sort_constructor": true
    }
  }
}
```

Before:
```objc
...
/**
 * @param syncMsgVersion - syncMsgVersion
 * @param language - language
 * @param hmiDisplayLanguage - hmiDisplayLanguage
 * @param displayCapabilities - displayCapabilities
 * @param buttonCapabilities - buttonCapabilities
 * @param softButtonCapabilities - softButtonCapabilities
 * @param presetBankCapabilities - presetBankCapabilities
 * @param hmiZoneCapabilities - hmiZoneCapabilities
 * @param speechCapabilities - speechCapabilities
 * @param prerecordedSpeech - prerecordedSpeech
 * @param vrCapabilities - vrCapabilities
 * @param audioPassThruCapabilities - audioPassThruCapabilities
 * @param pcmStreamCapabilities - pcmStreamCapabilities
 * @param vehicleType - vehicleType
 * @param supportedDiagModes - supportedDiagModes
 * @param hmiCapabilities - hmiCapabilities
 * @param sdlVersion - sdlVersion
 * @param systemSoftwareVersion - systemSoftwareVersion
 * @param iconResumed - @(iconResumed)
 * @return A SDLRegisterAppInterfaceResponse object
 */
- (instancetype)initWithSyncMsgVersion:(nullable SDLSyncMsgVersion *)syncMsgVersion language:(nullable SDLLanguage)language hmiDisplayLanguage:(nullable SDLLanguage)hmiDisplayLanguage displayCapabilities:(nullable SDLDisplayCapabilities *)displayCapabilities buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities softButtonCapabilities:(nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities presetBankCapabilities:(nullable SDLPresetBankCapabilities *)presetBankCapabilities hmiZoneCapabilities:(nullable NSArray<SDLHmiZoneCapabilities> *)hmiZoneCapabilities speechCapabilities:(nullable NSArray<SDLSpeechCapabilities> *)speechCapabilities prerecordedSpeech:(nullable NSArray<SDLPrerecordedSpeech> *)prerecordedSpeech vrCapabilities:(nullable NSArray<SDLVrCapabilities> *)vrCapabilities audioPassThruCapabilities:(nullable NSArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities pcmStreamCapabilities:(nullable SDLAudioPassThruCapabilities *)pcmStreamCapabilities vehicleType:(nullable SDLVehicleType *)vehicleType supportedDiagModes:(nullable NSArray<NSNumber<SDLUInt> *> *)supportedDiagModes hmiCapabilities:(nullable SDLHMICapabilities *)hmiCapabilities sdlVersion:(nullable NSString *)sdlVersion systemSoftwareVersion:(nullable NSString *)systemSoftwareVersion iconResumed:(BOOL)iconResumed;
...
```

After:
```objc
/**
 * @param audioPassThruCapabilities - audioPassThruCapabilities
 * @param buttonCapabilities - buttonCapabilities
 * @param displayCapabilities - displayCapabilities
 * @param hmiCapabilities - hmiCapabilities
 * @param hmiDisplayLanguage - hmiDisplayLanguage
 * @param hmiZoneCapabilities - hmiZoneCapabilities
 * @param iconResumed - @(iconResumed)
 * @param language - language
 * @param pcmStreamCapabilities - pcmStreamCapabilities
 * @param prerecordedSpeech - prerecordedSpeech
 * @param presetBankCapabilities - presetBankCapabilities
 * @param sdlVersion - sdlVersion
 * @param softButtonCapabilities - softButtonCapabilities
 * @param speechCapabilities - speechCapabilities
 * @param supportedDiagModes - supportedDiagModes
 * @param syncMsgVersion - syncMsgVersion
 * @param systemSoftwareVersion - systemSoftwareVersion
 * @param vehicleType - vehicleType
 * @param vrCapabilities - vrCapabilities
 * @return A SDLRegisterAppInterfaceResponse object
 */
- (instancetype)initWithAudioPassThruCapabilities:(nullable NSArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities displayCapabilities:(nullable SDLDisplayCapabilities *)displayCapabilities hmiCapabilities:(nullable SDLHMICapabilities *)hmiCapabilities hmiDisplayLanguage:(nullable SDLLanguage)hmiDisplayLanguage hmiZoneCapabilities:(nullable NSArray<SDLHmiZoneCapabilities> *)hmiZoneCapabilities iconResumed:(BOOL)iconResumed language:(nullable SDLLanguage)language pcmStreamCapabilities:(nullable SDLAudioPassThruCapabilities *)pcmStreamCapabilities prerecordedSpeech:(nullable NSArray<SDLPrerecordedSpeech> *)prerecordedSpeech presetBankCapabilities:(nullable SDLPresetBankCapabilities *)presetBankCapabilities sdlVersion:(nullable NSString *)sdlVersion softButtonCapabilities:(nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities speechCapabilities:(nullable NSArray<SDLSpeechCapabilities> *)speechCapabilities supportedDiagModes:(nullable NSArray<NSNumber<SDLUInt> *> *)supportedDiagModes syncMsgVersion:(nullable SDLSyncMsgVersion *)syncMsgVersion systemSoftwareVersion:(nullable NSString *)systemSoftwareVersion vehicleType:(nullable SDLVehicleType *)vehicleType vrCapabilities:(nullable NSArray<SDLVrCapabilities> *)vrCapabilities;
```

## "-params"

If you need to remove some "elements|members|params", list them as follow:
```json
{
  "functions": {
    "RegisterAppInterfaceResponse": {
      "-params": [
        "syncMsgVersion"
      ]
    }
  }
}
```

Before:
```objc
...
@class SDLSyncMsgVersion;
...
/**
 * @param syncMsgVersion - syncMsgVersion
 * @param language - language
 * @param hmiDisplayLanguage - hmiDisplayLanguage
 * @return A SDLRegisterAppInterfaceResponse object
 */
- (instancetype)initWithSyncMsgVersion:(nullable SDLSyncMsgVersion *)syncMsgVersion language:(nullable SDLLanguage)language hmiDisplayLanguage:(nullable SDLLanguage)hmiDisplayLanguage;

@property (nullable, strong, nonatomic) SDLSyncMsgVersion *syncMsgVersion;
...
```

After:
```objc
...
/**
 * @param language - language
 * @param hmiDisplayLanguage - hmiDisplayLanguage
 * @return A SDLRegisterAppInterfaceResponse object
 */
- (instancetype)initWithLanguage:(nullable SDLLanguage)language hmiDisplayLanguage:(nullable SDLLanguage)hmiDisplayLanguage;
...
```

As result generated listed "elements|members|params" will be removed from appropriate getters/setters, initiators (constructors) and imports.

## "params_title"

Used for Enums only.

To avoid capitalizing elements (used named from original source XML) use following parameter:
```json
{
  "enums": {
    "AudioType": {
      "params_title": false
    }
  }
}
```

Before:
```objc
...
extern SDLAudioType const SDLAudioTypePcm;
...
```

After:
```objc
..
extern SDLAudioType const SDLAudioTypePCM;
...
```

## Customization sub elements|params|members

## `Enum` elements customization

### "value"

```json
{
  "enums": {
    "FunctionID": {
      "PerformInteractionID": {
        "value": "0XFF"
      }
    }
  }
}
```

Before:
```objc
...
@10: SDLRPCFunctionNamePerformInteraction,
...
```

After:
```objc
...
@0XFF: SDLRPCFunctionNamePerformInteraction,
...
```

## `Struct` members and `Function` params customization

### "origin"

changing of "origin" also will affect "constructor_argument", "constructor_prefix" and "method_suffix"

```json
{
  "structs": {
    "RdsData": {
      "PS": {
        "origin": "programService"
      }
    }
  }
}
```

Before:
```objc
...
- (instancetype)initWithPS:(nullable NSString *)PS
...
@property (nullable, strong, nonatomic) NSString *PS;
...
```

After:
```objc
...
- (instancetype)initWithProgramService:(nullable NSString *)programService
...
@property (nullable, strong, nonatomic) NSString *programService;
...
```

### "constructor_argument"

initiator (constructor) parameter name

```json
{
  "structs": {
    "KeyboardProperties": {
      "limitedCharacterList": {
        "constructor_argument": "example_limitedCharacterList"
      }
    }
  }
}
```

After:

sdl_ios/SmartDeviceLink/SDLKeyboardProperties.h
```objc
...
/**
 * @param language - language
 * @param example_limitedCharacterList - example_limitedCharacterList
 * @return A SDLKeyboardProperties object
 */
- (instancetype)initWithLanguage:(nullable SDLLanguage)language limitedCharacterList:(nullable NSArray<NSString *> *)example_limitedCharacterList;
...
```

sdl_ios/SmartDeviceLink/SDLKeyboardProperties.m
```objc
...
- (instancetype)initWithLanguage:(nullable SDLLanguage)language limitedCharacterList:(nullable NSArray<NSString *> *)example_limitedCharacterList{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.language = language;
    self.limitedCharacterList = example_limitedCharacterList;
...
```

### "constructor_argument_override"

```json
{
  "structs": {
    "KeyboardProperties": {
      "limitedCharacterList": {
        "constructor_argument_override": "[limitedCharacterList mutableCopy]"
      }
    }
  }
}
```

After:

sdl_ios/SmartDeviceLink/SDLKeyboardProperties.h
```objc
...
/**
 * @param language - language
 * @param limitedCharacterList - [limitedCharacterList mutableCopy]
 * @return A SDLKeyboardProperties object
 */
- (instancetype)initWithLanguage:(nullable SDLLanguage)language limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList;
...
```

sdl_ios/SmartDeviceLink/SDLKeyboardProperties.m
```objc
...
- (instancetype)initWithLanguage:(nullable SDLLanguage)language limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.language = language;
    self.limitedCharacterList = [limitedCharacterList mutableCopy];
...
```

### "constructor_prefix"

```json
{
  "structs": {
    "ImageResolution": {
      "resolutionWidth": {
        "constructor_prefix": "Width"
      }
    }
  }
}
```

Before:
```objc
...
/**
 * @param resolutionWidth - @(resolutionWidth)
 * @return A SDLImageResolution object
 */
- (instancetype)initWithResolutionWidth:(UInt16)resolutionWidth;
...
```

After:
```objc
...
/**
 * @param width - @(resolutionWidth)
 * @return A SDLImageResolution object
 */
- (instancetype)initWithWidth:(UInt16)resolutionWidth;
...
```

### "method_suffix"

```json
{
  "structs": {
    "TouchEvent": {
      "c": {
        "method_suffix": "Coordinate"
      }
    }
  }
}
```

Before:
```objc
...
- (void)setC:(NSArray<SDLTouchCoord *> *)c {
    [self.store sdl_setObject:c forName:SDLRPCParameterNameC];
}

- (NSArray<SDLTouchCoord *> *)c {
    NSError *error = nil;
    return [self.store sdl_objectsForName:SDLRPCParameterNameC ofClass:SDLTouchCoord.class error:&error];
}
...
```

After:
```objc
...
- (void)setC:(NSArray<SDLTouchCoord *> *)c {
    [self.store sdl_setObject:c forName:SDLRPCParameterNameCoordinate];
}

- (NSArray<SDLTouchCoord *> *)c {
    NSError *error = nil;
    return [self.store sdl_objectsForName:SDLRPCParameterNameCoordinate ofClass:SDLTouchCoord.class error:&error];
}
...
```

### "deprecated"

```json
{
  "structs": {
    "KeyboardProperties": {
      "autoCompleteText": {
        "deprecated": false
      }
    }
  }
}
```
```objc
...
@property (nullable, strong, nonatomic) NSString *autoCompleteText;
...
```
####
```json
{
  "structs": {
    "KeyboardProperties": {
      "autoCompleteText": {
        "deprecated": "long deprecation description"
      }
    }
  }
}
```
```objc
...
/**
 * @deprecated
 */
@property (nullable, strong, nonatomic) NSString *autoCompleteText __deprecated_msg("long deprecation description");
...
```
####
```json
{
  "structs": {
    "KeyboardProperties": {
      "autoCompleteText": {
        "deprecated": true
      }
    }
  }
}
```
```objc
...
/**
 * @deprecated
 */
@property (nullable, strong, nonatomic) NSString *autoCompleteText __deprecated;
...
```

### "mandatory"

```json
{
  "structs": {
    "Image": {
      "isTemplate": {
        "mandatory": true
      }
    }
  }
}
```

Before:
```objc
...
/**
 * @param value - value
 * @param imageType - imageType
 * @return A SDLImage object
 */
- (instancetype)initWithValue:(NSString *)value imageType:(SDLImageType)imageType;

/**
 * @param value - value
 * @param imageType - imageType
 * @param isTemplate - @(isTemplate)
 * @return A SDLImage object
 */
- (instancetype)initWithValue:(NSString *)value imageType:(SDLImageType)imageType isTemplate:(BOOL)isTemplate;
...
/**
 * Optional, BOOL
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *isTemplate;
...
```

After:
```objc
...
/**
 * @param value - value
 * @param imageType - imageType
 * @param isTemplate - @(isTemplate)
 * @return A SDLImage object
 */
- (instancetype)initWithValue:(NSString *)value imageType:(SDLImageType)imageType isTemplate:(BOOL)isTemplate;
...
/**
 * Required, BOOL
 */
@property (strong, nonatomic) NSNumber<SDLBool> *isTemplate;
...
```

### "since"

```json
{
  "structs": {
    "AppServiceManifest": {
      "rpcSpecVersion": {
        "since": "5.0.0"
      }
    }
  }
}
```

Before:
```objc
...
/**
 * This is the max RPC Spec version the app service understands. This is important during the RPC passthrough
 * functionality. If not included, it is assumed the max version of the module is acceptable.
 *
 * Optional, SDLSyncMsgVersion *
 */
@property (nullable, strong, nonatomic) SDLSyncMsgVersion *rpcSpecVersion;
...
```

After:
```objc
...
/**
 * This is the max RPC Spec version the app service understands. This is important during the RPC passthrough
 * functionality. If not included, it is assumed the max version of the module is acceptable.
 *
 * @since SDL 5.0.0
 *
 * Optional, SDLSyncMsgVersion *
 */
@property (nullable, strong, nonatomic) SDLSyncMsgVersion *rpcSpecVersion;
...
```

### "of_class"

```json
{
  "functions": {
    "AddSubMenuRequest": {
      "menuIcon": {
        "of_class": "[SDLImage class]"
      }
    }
  }
}
```

Before:
```objc
...
- (nullable SDLImage *)menuIcon {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuIcon ofClass:SDLImage.class error:nil];
}
...
```

After:
```objc
...
- (nullable SDLImage *)menuIcon {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuIcon ofClass:[SDLImage class] error:nil];
}
...
```


### "type_native"

```json
{
  "structs": {
    "LightState": {
      "density": {
        "type_native": "double"
      }
    }
  }
}
```

Before:
```objc
...
- (instancetype)initWithId:(SDLLightName)id status:(SDLLightStatus)status density:(float)density color:(nullable SDLRGBColor *)color;
...
```

After:
```objc
...
- (instancetype)initWithId:(SDLLightName)id status:(SDLLightStatus)status density:(double)density color:(nullable SDLRGBColor *)color;
...
```

### "type_sdl"

```json
{
  "functions": {
    "RegisterAppInterfaceRequest": {
      "appHMIType": {
        "type_sdl": "NSArray<SDLAppHMIType *> *"
      }
    }
  }
}
```

sdl_ios/SmartDeviceLink/SDLRegisterAppInterface.h

Before:
```objc
...
@property (nullable, strong, nonatomic) NSArray<SDLAppHMIType> *appHMIType;
...
```

After:
```objc
...
@property (nullable, strong, nonatomic) NSArray<SDLAppHMIType *> *appHMIType;
...
```

### "modifier"

```json
{
  "structs": {
    "LocationDetails": {
      "locationName": {
        "modifier": "copy"
      }
    }
  }
}
```

Before:
```objc
...
@property (nullable, strong, nonatomic) NSString *locationName;
...
```

After:
```objc
...
@property (nullable, copy, nonatomic) NSString *locationName;
...
```

### "for_name"

```json
{
  "structs": {
    "VehicleDataResult": {
      "oemCustomDataType": {
        "for_name": "enum"
      }
    }
  }
}
```

Before:
```objc
...
- (nullable NSString *)oemCustomDataType {
    return [self.store sdl_objectForName:SDLRPCParameterNameOemCustomDataType ofClass:NSString.class error:nil];
}
...
```

After:
```objc
...
- (nullable NSString *)oemCustomDataType {
    return [self.store sdl_enumForName:SDLRPCParameterNameOemCustomDataType ofClass:NSString.class error:nil];
}
...
```


### "description"

```json
{
  "functions": {
    "RegisterAppInterfaceResponse": {
      "syncMsgVersion": {
        "description": "Specifies the negotiated version number of the SmartDeviceLink protocol that is to be supported by the mobile application."
      }
    }
  }
}
```

Before:
```objc
...
/**
 * See SyncMsgVersion
 */
@property (nullable, strong, nonatomic) SDLSyncMsgVersion *syncMsgVersion;
...
```

After:
```objc
...
/**
 * Specifies the negotiated version number of the SmartDeviceLink protocol that is to be supported by the mobile
 * application.
 */
@property (nullable, strong, nonatomic) SDLSyncMsgVersion *syncMsgVersion;
...
```
