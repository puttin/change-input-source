#!/usr/bin/env xcrun --sdk macosx swift -target x86_64-macosx10.12
// alternative:
// https://github.com/noraesae/kawa
// https://github.com/minoki/InputSourceSelector

// Legacy Carbon Related Docs:
// …/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Carbon.framework/…/HIToolbox.framework/…/TextInputSources.h
// …/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Carbon.framework/…/HIToolbox.framework/…/Keyboards.h
// …/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Carbon.framework/…/HIToolbox.framework/…/TextServices.h

// https://stackoverflow.com/questions/34120142/swift-cfarray-get-values-as-utf-strings/34121525
// weird system bug? https://github.com/noraesae/kawa/issues/3

import Carbon

let availableInputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
let availableInputSource = availableInputSourceNSArray as! [TISInputSource]

let inputSourceMap = availableInputSource.reduce(into: [String: TISInputSource]()) { dict, inputSource in
    let ptr = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)!
    let inputSourceID = Unmanaged<CFString>.fromOpaque(ptr).takeUnretainedValue() as String
    dict[inputSourceID] = inputSource
}
print("Available Input Source:")
inputSourceMap.forEach {
    debugPrint($0, $1)
}
print("-----------------------")

debugPrint("Arguments:", CommandLine.arguments)
precondition(CommandLine.arguments.count == 2, "Needs an inputSourceID argument")

let targetInputSourceID = CommandLine.arguments[1]

if let targetInputSource = inputSourceMap[targetInputSourceID] {
    TISSelectInputSource(targetInputSource)
}
else {
    preconditionFailure("Unable to find an input source with ID '\(targetInputSourceID)'")
}

/*
let inputSourceIDKey: CFString = kTISPropertyInputSourceID!
let inputSourcePropertiesDict = [inputSourceIDKey as String: inputSourceID]
TISCreateInputSourceList(inputSourcePropertiesDict, false).takeRetainedValue()
*/
