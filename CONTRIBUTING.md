# Contributing to SmartDeviceLink-iOS

Third party contributions are essential for making this repository great. However, we do have a few guidelines we need contributors to follow.

### Issues
If writing a bug report, please make sure [it has enough info](http://yourbugreportneedsmore.info). Include all relevant information. 

If requesting a feature, understand that we appreciate the input! However, it may not immediately fit our roadmap, and it may take a while for us to get to your request, if we are able to at all.

### Gitflow
We use [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) as our branch management system. The main points you should know are:

### Pull Requests
* Please follow the [SDL iOS Style Guide](https://github.com/smartdevicelink/SmartDeviceLink-iOS/wiki/Objective-C-Style-Guide)
* All feature branches should be based on `develop` and have the format `feature/branch_name`.
* Minor bug fixes, that is bug fixes that do not change, add, or remove any public API, should be based on `master` and have the format `hotfix/branch_name`.
* All pull requests should involve a single change. Pull Requests that involve multiple changes (it is our discretion what precisely this means) will be rejected with a reason.
* All commits should involve logical units. Please do not put all changed code in one commit, unless it is a very minor change.
* Work in progress pull requests should have "[WIP]" in front of the Pull Request title. When you believe the pull request is ready to merge, remove this tag and @mention `smartdevicelink/ios` to get it scheduled for review.
* If applicable, follow [this Pull Request's format](https://github.com/smartdevicelink/SmartDeviceLink-iOS/pull/45).
* Please document all code written. Write [objective-c style documentation](http://nshipster.com/documentation/) for methods (we use [VVDocumenter](https://github.com/onevcat/VVDocumenter-Xcode) to help out, and use inline code comments where it makes sense, i.e. for non-obvious code chunks.
* As of SDL iOS 4.0, all new code *must* be unit tested. We use [Quick](https://github.com/Quick/Quick), [Nimble](https://github.com/Quick/Nimble), and [OCMock](http://ocmock.org) currently. Bug fixes should have a test that fails previously and now passes. All new features should be covered. If your code does not pass tests, or regresses old tests, it will be rejected.

### Contributor's License Agreement (CLA)
In order to accept Pull Requests from contributors, you must first sign [the Contributor's License Agreement](https://docs.google.com/forms/d/1VNR8EUd5b46cQ7uNbCq1fJmnu0askNpUp5dudLKRGpU/viewform). If you need to make a change to information that you entered, [please contact us](mailto:justin@livio.io).
