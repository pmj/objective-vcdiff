# Objective-C wrapper for open-vcdiff

[Open-VCDiff][] is a open source library from Google, which allows you to create
and decode binary diffs. The library itself as well as the API are written in C++.
For iPhone or Mac apps, where you typically download diffs using NSURLConnection
or obtain them using other Objective-C APIs, this isn't terribly convenient.

This thin wrapper provides a pure Objective-C (not Objective-C++) interface for
the decoder part. It allows you to specify the dictionary using an NSData object,
the output as an NSFileHandle and feeding chunks of the diff as pure C byte
buffers or NSData objects. There is also a helper for loading the dictionary
from file. Internally, this memory-maps the file read-only as an NSData object.
Memory mapping avoids holding the entire file in memory at once, which would be
problematic on memory constrained systems, such as iOS devices.

The [Pimpl idiom][pimplobjc] is used to keep any C++ out of the headers, so this
is suitable to use with pure Objective-C apps. You will need to add
libstdc++.dylib to your app's dependencies, however.

To use this code in an XCode project, download the [Open-VCDiff][] source,
extract it, and run `./configure` (but generally not `make`). 
Add the 'src' directory, including the 'google'
subdirectory but excluding 'solaris' to a new target in your project (or a
sub-project), then add the source and header files from the src directory of this
repository. You'll want to omit all files ending in -test.cc, as well as
vcdiff_main.cc, which are needed only for the unit tests and the command line tool,
respectively. You will also want to add the path to the open-vcdiff 'src' directory
to the list of 'Search Headers' paths in your build target's settings. I've
added an example XCode project for building as a static library on iOS to the
objective-vcdiff-ios directory.

Your
own code will only need to #import "VCDiffDecoder.h", none of the google stuff.
About half of the open-vcdiff code is only used for encoding, so you can either
remove those files manually or let the deadstripper deal with them automatically
during the linking stage.

Open-VCDiff is subject to the Apache License 2.0, this wrapper is licensed under
the more permissive 3-clause BSD license. (no attribution required)

[open-vcdiff]: http://code.google.com/p/open-vcdiff/
[pimplobjc]: http://philjordan.eu/article/strategies-for-using-c++-in-objective-c-projects
