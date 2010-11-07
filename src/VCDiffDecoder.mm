//
//  VCDiffDecoder.mm
//
//  Created by Phil Jordan on 8/26/10.
/*  Copyright (c) 2010 Phillip Jordan.
 
 This software is provided 'as-is', without any express or implied
 warranty. In no event will the authors be held liable for any damages
 arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not
 claim that you wrote the original software. If you use this software
 in a product, an acknowledgment in the product documentation would be
 appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be
 misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source
 distribution.

 Uses Open-VCDiff, which is subject to the Apache License 2.0.

 */

#import "VCDiffDecoder.h"
#import <google/vcdecoder.h>

struct VCDiffDecoderImpl
{
	open_vcdiff::VCDiffStreamingDecoder decoder;
};

using open_vcdiff::VCDiffStreamingDecoder;
namespace open_vcdiff
{
	/// Implementation of OutputString for NSFileHandle
	template<>
	class OutputString<NSFileHandle> : public OutputStringInterface {
	public:
		explicit OutputString(NSFileHandle* impl) : impl_([impl retain]) { }
	
		virtual ~OutputString() {
			[impl_ release];
		}
	
		virtual OutputString& append(const char* s, size_t n) {
			NSData* d = [[NSData dataWithBytesNoCopy:const_cast<char*>(s) length:n freeWhenDone:NO] retain];
			[impl_ writeData:d];
			[d release];
			return *this;
		}
		
		virtual void clear() {
			[impl_ truncateFileAtOffset:0];
		}
		
		virtual void push_back(char c) {
			NSData* d = [NSData dataWithBytes:&c length:1];
			[d retain];
			[impl_ writeData:d];
			[d release];
		}
		
		virtual void ReserveAdditionalBytes(size_t res_arg) {
			// no-op
		}
		
		virtual size_t size() const {
			return [impl_ offsetInFile];
		}
		
	protected:
		NSFileHandle* impl_;
		
	private:
		// Making these private avoids implicit copy constructor & assignment operator
		OutputString(const OutputString&);
		void operator=(const OutputString&);
	};
}

@implementation VCDiffDecoder
@synthesize outputFileHandle;
@synthesize dictionary;

+ (VCDiffDecoder*)diffDecoderWithMMappedDictionaryAtPath:(NSString*)dictionaryFile writingOutputTo:(NSFileHandle*)handle
{
	NSData* dict = [NSData dataWithContentsOfMappedFile:dictionaryFile];
	if (!dict)
		return nil;
	
	VCDiffDecoder* dec = [[VCDiffDecoder alloc] initWithDictionary:dict writingOutputTo:handle];
	[dec autorelease];
	return dec;
}

- (id)initWithDictionary:(NSData*)dict writingOutputTo:(NSFileHandle*)handle
{
	self = [super init];
	if (self)
	{
		self.outputFileHandle = handle;
		self.dictionary = dict;
		impl = new VCDiffDecoderImpl;
		impl->decoder.StartDecoding(static_cast<const char*>([dict bytes]), [dict length]);
	}
	return self;
}

- (BOOL)decodeData:(NSData*)diffData
{
	return impl->decoder.DecodeChunk(static_cast<const char*>([diffData bytes]), [diffData length], outputFileHandle);
}
- (BOOL)decodeChars:(const char*)bytes length:(size_t)length
{
	return impl->decoder.DecodeChunk(bytes, length, outputFileHandle);
}
- (BOOL)decodeBytes:(const unsigned char*)bytes length:(size_t)length
{
	return [self decodeChars:(const char*)bytes length:length];
}

- (BOOL)finishDecoding
{
	return impl->decoder.FinishDecoding();
}

- (void)dealloc
{
	delete impl;
	impl = NULL;
	self.outputFileHandle = nil;
	self.dictionary = nil;
	[super dealloc];
}

@end
