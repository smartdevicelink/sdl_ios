# Proxy Library RPC Generator

This script provides the ability to auto-generate Objective-C RPC code (header \*.h and implementation \*.m classes) based on the SDL MOBILE_API XML specification.

## Requirements

The script requires **Python 3** pre-installed on the host system. The minimal supported Python 3 version is **3.7.6**. It may work on versions back to 3.5 (the minimal version that has not yet reached [the end-of-life](https://devguide.python.org/devcycle/#end-of-life-branches)), but this is not supported and may break in the future.

Note: To install versions of Python 3, you must use the **pip3** command.

All required libraries are listed in `requirements.txt` and should be pre-installed on the system prior to using the sript. Please use the following command to install the libraries:

```shell script
$ pip3 install -r generator/requirements.txt
```

Please also make sure all git submodules are installed and up to date since the script uses the XML parser provided in a submodule.

```shell script
$ git submodule update --init --recursive
```

## Usage

**Usage example**

```shell script
$ cd sdl_ios
$ python3 generator/generator.py -xml generator/rpc_spec/MOBILE_API.xml -xsd generator/rpc_spec/MOBILE_API.xsd -d output_dir
```


As a result the output_dir will have all the new generated files.

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

All RPC classes used in **SmartDeviceLink iOS** library were created manually due to historical reasons and have public API differences from the RPC_SPEC. Therefore, the generated files will differ from the current ones. The generated files are based on the RPC_SPEC and do not contain changes to match the existing files. Therefore, do not replace existing files with generated files. If you want to update existing files with new parameters using the generator, you must generate the file and then use a diff tool to add only the new information and not to change existing information. 

If you are adding new RPCs entirely, you can generate those RPCs. Use the `--skip` switch to only generate new files. You must add those files to Xcode project, SmartDeviceLink.h, and podspec files manually and place them in proper groups sorting the files by their kind. Note: the groups are just virtual folders; they do not map to the file system, so all files go to the SmartDeviceLink folder on the file system.


## Objective-C transformation rules

### Overview
These are the general transformation rules for SDL RPC classes Objective-C Library. For more information about the base classes for these RPCs, you can look in the app library.

### Output Directory Structure and Package definitions
The script creates corresponding RPC classes of `<enum>`, `<struct>` and `<function>` elements following the `MOBILE_API.xml` rules. According to existing structure of sdl_ios library the output directory will contain the following files (plain structure, no subfolders).

RPC requests, responses, structs, enums, and notifications file names all have the form:

* SDLxxx.h
* SDLxxx.m

Responses have the form:

* SDLxxxResponse.h
* SDLxxxResponse.m

Where the **xxx** is the correspondent item name.

### The License Header

All files should begin with the license information.

```jinja2
/*
 * Copyright (c) {{year}}, SmartDeviceLink Consortium, Inc.
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

Where `{{year}}` in the copyright line is the current year.

### General rules for Objective-C classes
1. Default initializer applies only to Functions(Request / Response / Notification) classes

```objc
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameRegisterAppInterface];
    if (!self) { return nil; }

    return self;
}
```

2. Initializer for mandatory params if there is/are any in XML (skipped if no <mandatory = true> params)
3. Initializer for all params if there is/are any which is not mandatory in XML (skipped if no <mandatory = false> params)

#### Scalars
There are 4 type of scalar values declared in the SDL lib.  These are:
1. **SDLInt** - A declaration that this NSNumber contains an NSInteger.
0. **SDLUInt** - A declaration that this NSNumber contains an NSUInteger.
0. **SDLBool** - A declaration that this NSNumber contains a BOOL.
0. **SDLFloat** - A declaration that this NSNumber contains a float.

*Note: These are syntactic sugar to help the developer know what type of value is held in the `NSNumber`.*

Usage example:
```objc
@property (strong, nonatomic) NSNumber<SDLInt> *touchEventId;
```

or in an array:
```objc
@property (strong, nonatomic) NSArray<NSNumber<SDLInt> *> *timeStamp;
```

#### Enums
RPC Enums in SDL are strings. sdl_ios uses `NSString` `typedef`ed with a proper enum type. In Swift projects, however, they become real enums by using the `NS_SWIFT_ENUM` compiler tag.

Base definition of `SDLEnum`:

```objc
typedef NSString* SDLEnum SDL_SWIFT_ENUM;

*Note: This new defined type has already adds a pointer, so anything that inherits from `SDLEnum` needs no asterisk.*

```objc
typedef SDLEnum SDLTouchType SDL_SWIFT_ENUM; // SDLTouchType will be considered an NSString by the compiler in Obj-C, but will be an enum object of type SDLTouchType in Swift.
```

And here is a concrete 'enum' item:

```objc
extern SDLTouchType const SDLTouchTypeBegin;
```

If an item is deprecated then it will be declared as such:

```objc
__deprecated
extern SDLTouchType const SDLTouchTypeBegin;
```

Take for an instance the enum class KeypressMode
 
```xml
<enum name="KeypressMode" since="3.0">
    <description>Enumeration listing possible keyboard events.</description>
    <element name="SINGLE_KEYPRESS">
        <description>Each keypress is individually sent as the user presses the keyboard keys.</description>
    </element>
    <!-- Other elements -->
</enum>
```

In the following example, we would define in the header:

```objc
extern SDLKeypressMode const SDLKeypressModeSingleKeypress;
```

and `SDLKeypressModeSingleKeypress` itself must be implemented in the correspondent `SDLKeypressMode.m ` file like so:

```objc
SDLKeypressMode const SDLKeypressModeSingleKeypress = @"SINGLE_KEYPRESS";
```

#### Structs

Structures in sdl_ios are implemented as classes derived from the parent class SDLRPCStruct with all parameters implemented as `@property`. Let us take for an instance the `DeviceInfo` structure. In the XML it is declared as following:

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
 
*Note: the file begins with the `NS_ASSUME_NONNULL_BEGIN` macro, which makes all properties / parameters mandatory. If a parameter is not mandatory, then the modifier `nullable` must be used*

```objc
//  SDLDeviceInfo.h

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Various information about connecting device.
 *
 * @since SDL 3.0.0
 */
@interface SDLDeviceInfo : SDLRPCStruct

/**
 * @param hardware - hardware
 * @param firmwareRev - firmwareRev
 * @param os - os
 * @param osVersion - osVersion
 * @param carrier - carrier
 * @param maxNumberRFCOMMPorts - @(maxNumberRFCOMMPorts)
 * @return A SDLDeviceInfo object
 */
- (instancetype)initWithHardware:(nullable NSString *)hardware firmwareRev:(nullable NSString *)firmwareRev os:(nullable NSString *)os osVersion:(nullable NSString *)osVersion carrier:(nullable NSString *)carrier maxNumberRFCOMMPorts:(UInt8)maxNumberRFCOMMPorts;

/**
 * Device model
 * {"default_value": null, "max_length": 500, "min_length": 0}
 */
@property (nullable, strong, nonatomic) NSString *hardware;

/**
 * Device firmware revision
 * {"default_value": null, "max_length": 500, "min_length": 0}
 */
@property (nullable, strong, nonatomic) NSString *firmwareRev;

/**
 * Device OS
 * {"default_value": null, "max_length": 500, "min_length": 0}
 */
@property (nullable, strong, nonatomic) NSString *os;

/**
 * Device OS version
 * {"default_value": null, "max_length": 500, "min_length": 0}
 */
@property (nullable, strong, nonatomic) NSString *osVersion;

/**
 * Device mobile carrier (if applicable)
 * {"default_value": null, "max_length": 500, "min_length": 0}
 */
@property (nullable, strong, nonatomic) NSString *carrier;

/**
 * Omitted if connected not via BT.
 * {"default_value": null, "max_value": 100, "min_value": 0}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *maxNumberRFCOMMPorts;

@end

NS_ASSUME_NONNULL_END
```

The implementation **SDLDeviceInfo.m** file:

```objc
//  SDLDeviceInfo.m

#import "SDLDeviceInfo.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeviceInfo

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
    [self.store sdl_setObject:firmwareRev forName:SDLRPCParameterNameFirmwareRev];
}

- (nullable NSString *)firmwareRev {
    return [self.store sdl_objectForName:SDLRPCParameterNameFirmwareRev ofClass:NSString.class error:nil];
}

- (void)setOs:(nullable NSString *)os {
    [self.store sdl_setObject:os forName:SDLRPCParameterNameOs];
}

- (nullable NSString *)os {
    return [self.store sdl_objectForName:SDLRPCParameterNameOs ofClass:NSString.class error:nil];
}

- (void)setOsVersion:(nullable NSString *)osVersion {
    [self.store sdl_setObject:osVersion forName:SDLRPCParameterNameOsVersion];
}

- (nullable NSString *)osVersion {
    return [self.store sdl_objectForName:SDLRPCParameterNameOsVersion ofClass:NSString.class error:nil];
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

#### Functions

Functions in iOS are implemented as 3 different classes (`SDLRPCRequest`, `SDLRPCResponse`, and `SDLRPCNotification`) grouped by their respective type. All the 3 extend the common parent class `SDLRPCMessage`.


##### Function ID, Function Name, and Parameter Name Special Case Class
There is also the `SDLFunctionID` class generated though it is not declared in the XML. This class maps all function IDs that are integers to function names as strings.

1. Uses of the `"name"` attribute should be normalized by the removal of the ID suffix, e.g. `RegisterAppInterfaceID -> RegisterAppInterface`. 
2. The constant name should be camel case formatted.
3. The constant has 2 fields the first is the `int` value of the `"value"` attribute and the second is the `String` value of normalized `"name"` attribute.

Internally it uses another file that lists all the function names `SDLRPCFunctionNames`.

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

Each <function> from MOBILE_API.XML declares its function name in `SDLRPCFunctionNames.h` and `SDLRPCFunctionNames.m` files.

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

##### Request Functions (SDLRPCRequest)


```xml
    <function name="GetCloudAppProperties" functionID="GetCloudAppPropertiesID" messagetype="request" since="5.1">
        <description>
            RPC used to get the current properties of a cloud application
        </description> 
        <param name="appID" type="String" maxlength="100" mandatory="true"></param>
    </function>
```


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
    self = [super initWithName:SDLRPCFunctionNameGetCloudAppProperties];
    if (!self) { return nil; }

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

##### Response Functions (SDLRPCResponse)


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
    self = [super initWithName:SDLRPCFunctionNameShowAppMenu];
    if (!self) { return nil; }

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

##### Notification Functions (SDLRPCNotification)


```xml
<function name="OnAppInterfaceUnregistered" functionID="OnAppInterfaceUnregisteredID" messagetype="notification" since="1.0">
	<param name="reason" type="AppInterfaceUnregisteredReason" mandatory="true">
	    <description>See AppInterfaceUnregisteredReason</description>
	</param>
</function>
```

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
    self = [super initWithName:SDLRPCFunctionNameOnAppInterfaceUnregistered];
    if (!self) { return nil; }

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

## Other Utilities

### Generator

Proxy Library RPC Generator inherits the license defined in the root folder of this project.

#### Third Party Licenses

Both the source and binary distributions of this software contain
some third party software. All the third party software included
or linked is redistributed under the terms and conditions of their 
original licenses.

The third party software included and used by this project is:

**xmlschema**

* Licensed under MIT License
* See [https://pypi.org/project/xmlschema/](https://pypi.org/project/xmlschema/)

**Jinja2**

* Licensed under BSD License (BSD-3-Clause)
* See [https://pypi.org/project/Jinja2/](https://pypi.org/project/Jinja2/)

**coverage**

* Licensed under Apache Software License (Apache 2.0)
* See [https://pypi.org/project/coverage/](https://pypi.org/project/coverage/)

**pathlib2**

* Licensed under MIT License
* See [https://pypi.org/project/pathlib2/](https://pypi.org/project/pathlib2/)

**flake8**

* Licensed under MIT License
* See [https://pypi.org/project/flake8/](https://pypi.org/project/flake8/)
