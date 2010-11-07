//
//  VCDiffDecoder.h
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

#import <Foundation/Foundation.h>

struct VCDiffDecoderImpl;

@interface VCDiffDecoder : NSObject {
	struct VCDiffDecoderImpl* impl;
	NSFileHandle* outputFileHandle;
	NSData* dictionary;
}
@property (retain,nonatomic) NSFileHandle* outputFileHandle;
@property (retain,nonatomic) NSData* dictionary;

+ (VCDiffDecoder*)diffDecoderWithMMappedDictionaryAtPath:(NSString*)dictionaryFile writingOutputTo:(NSFileHandle*)handle;

- (id)initWithDictionary:(NSData*)dictionary writingOutputTo:(NSFileHandle*)handle;
- (BOOL)decodeData:(NSData*)diffData;
- (BOOL)decodeChars:(const char*)bytes length:(size_t)length;
- (BOOL)decodeBytes:(const unsigned char*)bytes length:(size_t)length;
- (BOOL)finishDecoding;

@end

