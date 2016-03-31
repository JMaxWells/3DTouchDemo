//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2015-2016, quncaotech
//	http://www.quncaotech.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#ifndef __LKSINGLETON_H__
#define __LKSINGLETON_H__

#import <Foundation/Foundation.h>

#undef	DECLARE_SINGLETON
#define DECLARE_SINGLETON( ... ) \
    - (instancetype)sharedInstance; \
    + (instancetype)sharedInstance;

#undef	IMPLEMENT_SINGLETON
#define IMPLEMENT_SINGLETON( ... ) \
    - (instancetype)sharedInstance \
    { \
        return [[self class] sharedInstance]; \
    } \
    + (instancetype)sharedInstance \
    { \
        static dispatch_once_t once; \
        static id __singleton__; \
        dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
        return __singleton__; \
    }

#define IMPLEMENT_SINGLETON_AUTOLOAD( __class ) \
    IMPLEMENT_SINGLETON( __class ) \
    + (void)load \
    { \
        [self sharedInstance]; \
    }

#endif