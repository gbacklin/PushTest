# Firebase iOS SDKs

This directory contains the full Firebase distribution, packaged as static
frameworks that can be integrated into your app.

# Integration Instructions

Each Firebase component requires several frameworks in order to function
properly. Each section below lists the frameworks you'll need to include
in your project in order to use that Firebase SDK in your application.

To integrate a Firebase SDK with your app:

1. Find the desired SDK in the list below.
2. Make sure you have an Xcode project open in Xcode.
3. In Xcode, hit `⌘-1` to open the Project Navigator pane. It will open on
   left side of the Xcode window if it wasn't already open.
4. Drag each framework from the "FirebaseAnalytics" directory into the Project
   Navigator pane. In the dialog box that appears, make sure the target you
   want the framework to be added to has a checkmark next to it, and that
   you've selected "Copy items if needed". If you already have Firebase
   frameworks in your project, make sure that you replace them with the new
   versions.
5. Drag each framework from the directory named after the SDK into the Project
   Navigator pane. Note that there may be no additional frameworks, in which
   case this directory will be empty. For instance, if you want the Database
   SDK, look in the Database folder for the required frameworks. In the dialog
   box that appears, make sure the target you want this framework to be added to
   has a checkmark next to it, and that you've selected "Copy items if needed."

   *Do not add the Firebase frameworks to the "Embed Frameworks" Xcode build
   phase. The Firebase frameworks are not embedded dynamic frameworks, but are
   [static frameworks](https://www.raywenderlich.com/65964/create-a-framework-for-ios)
   which cannot be embedded into your application's bundle.*

6. If the SDK has resources, go into the Resources folders, which will be in
   the SDK folder. Drag all of those resources into the Project Navigator, just
   like the frameworks, again making sure that the target you want to add these
   resources to has a checkmark next to it, and that you've selected "Copy items
   if needed".
7. Add the -ObjC flag to "Other Linker Settings":
  a. In your project settings, open the Settings panel for your target
  b. Go to the Build Settings tab and find the "Other Linker Flags" setting
     in the Linking section.
  c. Double-click the setting, click the '+' button, and add "-ObjC" (without
     quotes)
8. Drag the `Firebase.h` header in this directory into your project. This will
   allow you to `#import "Firebase.h"` and start using any Firebase SDK that you
   have.
9. If you're using Swift, or you want to use modules, drag module.modulemap into
   your project and update your User Header Search Paths to contain the
   directory that contains your module map.
10. You're done! Compile your target and start using Firebase.

If you want to add another SDK, repeat the steps above with the frameworks for
the new SDK. You only need to add each framework once, so if you've already
added a framework for one SDK, you don't need to add it again. Note that some
frameworks are required by multiple SDKs, and so appear in multiple folders.

The Firebase frameworks list the system libraries and frameworks they depend on
in their modulemaps. If you have disabled the "Link Frameworks Automatically"
option in your Xcode project/workspace, you will need to add the system
frameworks and libraries listed in each Firebase framework's
<Name>.framework/Modules/module.modulemap file to your target's or targets'
"Link Binary With Libraries" build phase.

"(~> X)" below means that the SDK requires all of the frameworks from X. You
should make sure to include all of the frameworks from X when including the SDK.

## FirebaseAnalytics
- FIRAnalyticsConnector.framework
- FirebaseAnalytics.framework
- FirebaseCore.framework
- FirebaseCoreDiagnostics.framework
- FirebaseInstanceID.framework
- GoogleAppMeasurement.framework
- GoogleDataTransport.framework
- GoogleDataTransportCCTSupport.framework
- GoogleUtilities.framework
- nanopb.framework

## FirebaseABTesting (~> FirebaseAnalytics)
- FirebaseABTesting.framework
- Protobuf.framework

## FirebaseAuth (~> FirebaseAnalytics)
- FirebaseAuth.framework
- GTMSessionFetcher.framework

## FirebaseDatabase (~> FirebaseAnalytics)
- FirebaseDatabase.framework
- leveldb-library.framework

## FirebaseDynamicLinks (~> FirebaseAnalytics)
- FirebaseDynamicLinks.framework

## FirebaseFirestore (~> FirebaseAnalytics)
- BoringSSL-GRPC.framework
- FirebaseFirestore.framework
- abseil.framework
- gRPC-C++.framework
- gRPC-Core.framework
- leveldb-library.framework

You'll also need to add the resources in the Resources
directory into your target's main bundle.

## FirebaseFunctions (~> FirebaseAnalytics)
- FirebaseFunctions.framework
- GTMSessionFetcher.framework

## FirebaseInAppMessaging (~> FirebaseAnalytics)
- FirebaseInAppMessaging.framework

## FirebaseInAppMessagingDisplay (~> FirebaseAnalytics)
- FirebaseInAppMessaging.framework
- FirebaseInAppMessagingDisplay.framework

You'll also need to add the resources in the Resources
directory into your target's main bundle.

## FirebaseMLModelInterpreter (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLModelInterpreter.framework
- GTMSessionFetcher.framework
- GoogleToolboxForMac.framework
- Protobuf.framework
- TensorFlowLiteC.framework
- TensorFlowLiteObjC.framework

## FirebaseMLNLLanguageID (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLNLLanguageID.framework
- FirebaseMLNaturalLanguage.framework
- GTMSessionFetcher.framework
- GoogleToolboxForMac.framework
- Protobuf.framework

## FirebaseMLNLSmartReply (~> FirebaseAnalytics)
- FirebaseABTesting.framework
- FirebaseMLCommon.framework
- FirebaseMLNLLanguageID.framework
- FirebaseMLNLSmartReply.framework
- FirebaseMLNaturalLanguage.framework
- FirebaseRemoteConfig.framework
- GTMSessionFetcher.framework
- GoogleToolboxForMac.framework
- Protobuf.framework

You'll also need to add the resources in the Resources
directory into your target's main bundle.

## FirebaseMLNLTranslate (~> FirebaseAnalytics)
- FirebaseABTesting.framework
- FirebaseMLCommon.framework
- FirebaseMLNLTranslate.framework
- FirebaseMLNaturalLanguage.framework
- FirebaseRemoteConfig.framework
- GTMSessionFetcher.framework
- GoogleToolboxForMac.framework
- Protobuf.framework

You'll also need to add the resources in the Resources
directory into your target's main bundle.

## FirebaseMLNaturalLanguage (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLNaturalLanguage.framework
- GTMSessionFetcher.framework
- GoogleToolboxForMac.framework
- Protobuf.framework

## FirebaseMLVision (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLVision.framework
- GTMSessionFetcher.framework
- GoogleAPIClientForREST.framework
- GoogleToolboxForMac.framework
- Protobuf.framework

## FirebaseMLVisionAutoML (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLVision.framework
- FirebaseMLVisionAutoML.framework
- GTMSessionFetcher.framework
- GoogleAPIClientForREST.framework
- GoogleToolboxForMac.framework
- Protobuf.framework
- TensorFlowLiteC.framework
- TensorFlowLiteObjC.framework

## FirebaseMLVisionBarcodeModel (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLVision.framework
- FirebaseMLVisionBarcodeModel.framework
- GoogleAPIClientForREST.framework
- GoogleToolboxForMac.framework

## FirebaseMLVisionFaceModel (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLVision.framework
- FirebaseMLVisionFaceModel.framework
- GoogleAPIClientForREST.framework
- GoogleToolboxForMac.framework

You'll also need to add the resources in the Resources
directory into your target's main bundle.

## FirebaseMLVisionLabelModel (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLVision.framework
- FirebaseMLVisionLabelModel.framework
- GoogleAPIClientForREST.framework
- GoogleToolboxForMac.framework

## FirebaseMLVisionObjectDetection (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLVision.framework
- FirebaseMLVisionObjectDetection.framework
- GTMSessionFetcher.framework
- GoogleAPIClientForREST.framework
- GoogleToolboxForMac.framework
- Protobuf.framework

## FirebaseMLVisionTextModel (~> FirebaseAnalytics)
- FirebaseMLCommon.framework
- FirebaseMLVision.framework
- FirebaseMLVisionTextModel.framework
- GoogleAPIClientForREST.framework
- GoogleToolboxForMac.framework

You'll also need to add the resources in the Resources
directory into your target's main bundle.

## FirebaseMessaging (~> FirebaseAnalytics)
- FirebaseMessaging.framework
- Protobuf.framework

## FirebasePerformance (~> FirebaseAnalytics)
- FirebaseABTesting.framework
- FirebasePerformance.framework
- FirebaseRemoteConfig.framework
- GTMSessionFetcher.framework
- GoogleToolboxForMac.framework
- Protobuf.framework

## FirebaseRemoteConfig (~> FirebaseAnalytics)
- FirebaseABTesting.framework
- FirebaseRemoteConfig.framework
- Protobuf.framework

## FirebaseStorage (~> FirebaseAnalytics)
- FirebaseStorage.framework
- GTMSessionFetcher.framework

## Google-Mobile-Ads-SDK (~> FirebaseAnalytics)
- GoogleMobileAds.framework

## GoogleSignIn
- AppAuth.framework
- GTMAppAuth.framework
- GTMSessionFetcher.framework
- GoogleSignIn.framework

You'll also need to add the resources in the Resources
directory into your target's main bundle.


# Samples

You can get samples for Firebase from https://github.com/firebase/quickstart-ios:

    git clone https://github.com/firebase/quickstart-ios

Note that several of the samples depend on SDKs that are not included with
this archive; for example, FirebaseUI. For the samples that depend on SDKs not
included in this archive, you'll need to use CocoaPods.

# Versions

The frameworks in this directory map to these versions of the Firebase SDKs in
CocoaPods.

            CocoaPod            | Version
--------------------------------|---------
AppAuth                         | 1.3.0
BoringSSL-GRPC                  | 0.0.3
Firebase                        | 6.14.0
FirebaseABTesting               | 3.1.2
FirebaseAnalytics               | 6.1.7
FirebaseAnalyticsInterop        | 1.4.0
FirebaseAuth                    | 6.4.1
FirebaseAuthInterop             | 1.0.0
FirebaseCore                    | 6.5.0
FirebaseCoreDiagnostics         | 1.1.2
FirebaseCoreDiagnosticsInterop  | 1.1.0
FirebaseDatabase                | 6.1.3
FirebaseDynamicLinks            | 4.0.6
FirebaseFirestore               | 1.8.2
FirebaseFunctions               | 2.5.1
FirebaseInAppMessaging          | 0.15.6
FirebaseInAppMessagingDisplay   | 0.15.5
FirebaseInstanceID              | 4.2.8
FirebaseMLCommon                | 0.19.0
FirebaseMLModelInterpreter      | 0.19.0
FirebaseMLNLLanguageID          | 0.17.0
FirebaseMLNLSmartReply          | 0.17.0
FirebaseMLNLTranslate           | 0.17.0
FirebaseMLNaturalLanguage       | 0.17.0
FirebaseMLVision                | 0.19.0
FirebaseMLVisionAutoML          | 0.19.0
FirebaseMLVisionBarcodeModel    | 0.19.0
FirebaseMLVisionFaceModel       | 0.19.0
FirebaseMLVisionLabelModel      | 0.19.0
FirebaseMLVisionObjectDetection | 0.19.0
FirebaseMLVisionTextModel       | 0.19.0
FirebaseMessaging               | 4.1.10
FirebasePerformance             | 3.1.8
FirebaseRemoteConfig            | 4.4.6
FirebaseStorage                 | 3.4.3
GTMAppAuth                      | 1.0.0
GTMSessionFetcher               | 1.3.0
Google-Mobile-Ads-SDK           | 7.53.0
GoogleAPIClientForREST          | 1.3.10
GoogleAppMeasurement            | 6.1.7
GoogleDataTransport             | 3.2.0
GoogleDataTransportCCTSupport   | 1.2.3
GoogleSignIn                    | 5.0.2
GoogleToolboxForMac             | 2.2.2
GoogleUtilities                 | 6.4.0
Protobuf                        | 3.11.1
TensorFlowLiteC                 | 1.14.0
TensorFlowLiteObjC              | 1.14.0
abseil                          | 0.20190808
gRPC-C++                        | 0.0.9
gRPC-Core                       | 1.21.0
leveldb-library                 | 1.22
nanopb                          | 0.3.9011

