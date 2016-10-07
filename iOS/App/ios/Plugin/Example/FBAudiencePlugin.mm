// ----------------------------------------------------------------------------
// FBAudiencePlugin.mm
//
/*
The MIT License (MIT)

Copyright (c) 2015 QuizTix Limited

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
// ----------------------------------------------------------------------------

// Import the plugin header
#import "FBAudiencePlugin.h"

// Apple
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
//#import <FBAudienceNetwork/FBNativeAd+ManualLoggingHelper.h>

// Corona
#import "CoronaRuntime.h"
#include "CoronaAssert.h"
#include "CoronaEvent.h"
#include "CoronaLua.h"
#include "CoronaLibrary.h"


@interface FBAudienceDelegate: UIViewController <FBNativeAdDelegate>

    // Reference to the current Lua listener function
    @property (nonatomic) Corona::Lua::Ref listenerRef;
    // Pointer to the current Lua state
    @property (nonatomic, assign) lua_State *L;

    //@property (nonatomic, assign) bool hasSurveyAvailable;
    @property (nonatomic, assign) bool isDebug;

@end

FBNativeAd *fbNativeAd;
NSMutableArray *placementStrings;

FBAudienceDelegate *fbAudienceDelegate;

// ----------------------------------------------------------------------------

@class UIViewController;

namespace Corona
{

// ----------------------------------------------------------------------------

class fbAudienceLibrary
{
	public:
		typedef fbAudienceLibrary Self;

	public:
		static const char kName[];
		
	public:
		static int Open( lua_State *L );
		static int Finalizer( lua_State *L );
		static Self *ToLibrary( lua_State *L );

	protected:
		fbAudienceLibrary();
		bool Initialize( void *platformContext );
		
	public:
		UIViewController* GetAppViewController() const { return fAppViewController; }

	public:
		static int init( lua_State *L );
        static int show( lua_State *L );
        void debugPrint(NSString* str);
    

	private:
		UIViewController *fAppViewController;
};

// ----------------------------------------------------------------------------

// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
const char fbAudienceLibrary::kName[] = "plugin.fbaudience";


int
fbAudienceLibrary::Open( lua_State *L )
{
	// Register __gc callback
	const char kMetatableName[] = __FILE__; // Globally unique string to prevent collision
	CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );
	
	//CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );
	void *platformContext = CoronaLuaGetContext( L );

	// Set library as upvalue for each library function
	Self *library = new Self;

	if ( library->Initialize( platformContext ) )
	{
		// Functions in library
		static const luaL_Reg kFunctions[] =
		{
			{ "init", init },
            { "show", show },
           

			{ NULL, NULL }
		};

		// Register functions as closures, giving each access to the
		// 'library' instance via ToLibrary()
		{
			CoronaLuaPushUserdata( L, library, kMetatableName );
			luaL_openlib( L, kName, kFunctions, 1 ); // leave "library" on top of stack
		}
	}

	return 1;
}

int
fbAudienceLibrary::Finalizer( lua_State *L )
{
	Self *library = (Self *)CoronaLuaToUserdata( L, 1 );
	delete library;
    
	// Free the Lua listener
	Corona::Lua::DeleteRef( fbAudienceDelegate.L, fbAudienceDelegate.listenerRef );
	fbAudienceDelegate.listenerRef = NULL;
    fbAudienceDelegate = nil;

	return 0;
}

fbAudienceLibrary *
fbAudienceLibrary::ToLibrary( lua_State *L )
{
	// library is pushed as part of the closure
	Self *library = (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
	return library;
}

fbAudienceLibrary::fbAudienceLibrary()
:	fAppViewController( nil )
{
}

bool
fbAudienceLibrary::Initialize( void *platformContext )
{
	bool result = ( ! fAppViewController );

	if ( result )
	{
		id<CoronaRuntime> runtime = (__bridge id<CoronaRuntime>)platformContext;
		fAppViewController = runtime.appViewController; // TODO: Should we retain?
	}

	return result;
}
	
    
   


// [Lua] tapdaq.init( options )
int
fbAudienceLibrary::init( lua_State *L )
{
    bool isDebug = false;
    
    int luaIDIndex = 1;
    int luaListenerIndex = 2;
    
    bool idFound = false;
    
	// The listener reference
	Corona::Lua::Ref listenerRef = NULL;
    
    
    if ( lua_type(L, luaListenerIndex) == LUA_TFUNCTION)
    {
        listenerRef = Corona::Lua::NewRef( L, luaListenerIndex );
    }
    else
    {
        luaL_error( L, "FB Audience Error: Second param is expected to be a function but was a %s", luaL_typename( L, -1 ) );
    }
    
    if ( lua_type(L, luaDebugIndex) == LUA_TBOOLEAN)
    {
        isDebug = lua_toboolean( L, luaDebugIndex );
        //NSLog(@"fbaudience initialised in debug mode");
    }
    else
    {
        luaL_error( L, "FB Audience Error: Third param is expected to be a boolean but was a %s", luaL_typename( L, -1 ) );
    }
    
    
    if ( fbAudienceDelegate == nil )
    {
        fbAudienceDelegate = [[FBAudienceDelegate alloc] init];
        // Assign the lua state so we can access it from within the delegate
        fbAudienceDelegate.L = L;
        // Set the callback reference to the listener ref we assigned above
        fbAudienceDelegate.listenerRef = listenerRef;
        fbAudienceDelegate.isDebug = isDebug;
    }
    
    
    if ( lua_type(L, luaDebugIndex) == LUA_TSTRING)
    {
    
        const char *valueChar = lua_tostring( L, luaIDIndex );
        NSString *valueString = [NSString stringWithFormat:@"%s" , valueChar];
    
        fbNativeAd = [[FBNativeAd alloc] initWithPlacementID:valueString];
        fbNativeAd.delegate = fbAudienceDelegate;
        
        idFound = true;
    }

    
	// Create dummy license event to maintain backwards compat
	if ( listenerRef != NULL && idFound == true)
	{
        // Create the event
        Corona::Lua::NewEvent( L, "fbaudience" );
        
        lua_pushstring( L, "init" );
        lua_setfield( L, -2, CoronaEventTypeKey() );
        
        lua_pushstring( L, "init" );
        lua_setfield( L, -2, "phase" );
        
        lua_pushboolean(L, false);
        lua_setfield( L, -2, "isError" );
            
        lua_pushstring( L, "fb audience init succesfully" );
        lua_setfield( L, -2, "message" );
            
        
        // Dispatch the event
        Corona::Lua::DispatchEvent( L, listenerRef, 1 );
	}
	
	return 0;
}
    
    
int
fbAudienceLibrary::show( lua_State *L )
{
    //NSLog(@"fbaudience calling show");
    if ( lua_type(L, 1) == LUA_TNUMBER)
    {
        //NSLog(@"type was number");
        int index = (int)lua_tointeger( L, 1 );
        index --;
        
        NSLog(@"show index is %i", index);
        [fbNativeAd loadAd];
        //NSLog(@"load ad called");
    }
    
    return 0;
}
    
    
    
    


  
    

    


 

	
// ----------------------------------------------------------------------------

} // namespace Corona

//

// FBAudience Delegate implementation
@implementation FBAudienceDelegate



- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{

    FBAdImage *coverImage = nativeAd.coverImage;
    NSString* imageurl = [coverImage.url absoluteString];
    const char *imageurlChar = [imageurl UTF8String];
    NSInteger imagewidth = coverImage.width;
    

    Corona::Lua::NewEvent( self.L, "fbaudience" );
    lua_pushstring( self.L, "fbaudience" );
    lua_setfield( self.L, -2, CoronaEventTypeKey() );
    
    // Push the phase string
    lua_pushstring( self.L, "show" );
    lua_setfield( self.L, -2, "phase" );
    
    
    lua_pushboolean(self.L, false );
    lua_setfield( self.L, -2, "isError" );
    
    lua_pushstring( self.L, imageurlChar );
    lua_setfield( self.L, -2, "coverurl" );
    
    lua_pushinteger( self.L, imagewidth );
    lua_setfield( self.L, -2, "coverwidth" );
    
    Corona::Lua::DispatchEvent( self.L, self.listenerRef, 1 );
    
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    NSLog(@"Ad failed to load with error: %@", error);

    NSString *placementID = nativeAd.placementID;
    const char *placementIDChar = [placementID UTF8String];

    Corona::Lua::NewEvent( self.L, "fbaudience" );
    lua_pushstring( self.L, "fbaudience" );
    lua_setfield( self.L, -2, CoronaEventTypeKey() );
    
    
    // Push the phase string
    lua_pushstring( self.L, "load" );
    lua_setfield( self.L, -2, "phase" );
    
    lua_pushstring( self.L, placementIDChar );
    lua_setfield( self.L, -2, "placementId" );
    
    lua_pushboolean(self.L, true );
    lua_setfield( self.L, -2, "isError" );
    
    
    Corona::Lua::DispatchEvent( self.L, self.listenerRef, 1 );
}




@end

// ----------------------------------------------------------------------------

CORONA_EXPORT
int luaopen_plugin_fbaudience( lua_State *L )
{
	return Corona::fbAudienceLibrary::Open( L );
}
