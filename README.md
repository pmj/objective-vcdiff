# Objective-C wrapper for open-vcdiff

[Open-VCDiff][] is a open source library from Google, which allows you to create and decode binary diffs. The library itself as well as the API are written in C++. For iPhone or Mac apps, where you typically download diffs using NSURLConnection or obtain them using other Objective-C APIs, this isn't terribly convenient.

This thin wrapper provides a pure Objective-C (not Objective-C++) interface for the decoder part. It allows you to specify the dictionary using an NSData object, the output as an NSFileHandle and feeding chunks of the diff as pure C byte buffers or NSData objects. There is also a helper for loading the dictionary from file. Internally, this memory-maps the file read-only as an NSData object. Memory mapping avoids holding the entire file in memory at once, which would be problematic on memory constrained systems, such as iOS devices.

The [Pimpl idiom][pimplobjc] is used to keep any C++ out of the headers, so this is suitable to use with pure Objective-C apps. You will need to add libstdc++.dylib to your app's dependencies, however.

[open-vcdiff]: http://code.google.com/p/open-vcdiff/
[pimplobj]: http://philjordan.eu/article/strategies-for-using-c++-in-objective-c-projects
