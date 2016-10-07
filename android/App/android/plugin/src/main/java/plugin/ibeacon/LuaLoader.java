//
//  LuaLoader.java
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// This corresponds to the name of the Lua library,
// e.g. [Lua] require "plugin.library"
package plugin.ibeacon;

import android.app.Activity;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import com.naef.jnlua.LuaState;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;
import com.ansca.corona.*;
import com.ansca.corona.CoronaActivity;
import com.ansca.corona.CoronaEnvironment;
import com.ansca.corona.CoronaLua;
import com.ansca.corona.CoronaRuntime;
import com.ansca.corona.CoronaRuntimeListener;

import java.util.ArrayList;

import com.easibeacon.protocol.IBeacon;
import com.easibeacon.protocol.IBeaconListener;
import com.easibeacon.protocol.IBeaconProtocol;
import com.easibeacon.protocol.Utils;

import android.annotation.SuppressLint;
import android.app.ListActivity;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;




/**
 * Implements the Lua interface for a Corona plugin.
 * <p>
 * Only one instance of this class will be created by Corona for the lifetime of the application.
 * This instance will be re-used for every new Corona activity that gets created.
 */
public class LuaLoader implements JavaFunction, CoronaRuntimeListener, IBeaconListener {
	/** Lua registry ID to the Lua function to be called when the ad request finishes. */
	private int fListener;

	/** This corresponds to the event name, e.g. [Lua] event.name */
	private static final String EVENT_NAME = "pluginibeaconevent";
	private CoronaRuntimeTaskDispatcher myRuntimeTaskDispatcher;

	final CoronaActivity activity = CoronaEnvironment.getCoronaActivity();

	private static final int REQUEST_BLUETOOTH_ENABLE = 1;

	private static ArrayList<IBeacon> _beacons;
	//private ArrayAdapter<IBeacon> _beaconsAdapter;
	private static IBeaconProtocol _ibp;

	public LuaLoader() {
		// Initialize member variables.
		fListener = CoronaLua.REFNIL;
		CoronaEnvironment.addRuntimeListener(this);
	}


	@Override
	public int invoke(LuaState L) {

		myRuntimeTaskDispatcher = new com.ansca.corona.CoronaRuntimeTaskDispatcher(L);

		// Register this plugin into Lua with the following functions.
		NamedJavaFunction[] luaFunctions = new NamedJavaFunction[] {
			new InitWrapper(),
				new ScanWrapper(),
				new StopWrapper(),
				new GetBeaconsWrapper()
		};
		String libName = L.toString( 1 );
		L.register(libName, luaFunctions);

		// Returning 1 indicates that the Lua require() function will return the above Lua library.
		return 1;
	}


	@Override
	public void onLoaded(CoronaRuntime runtime) {
	}

	@Override
	public void onStarted(CoronaRuntime runtime) {
	}

	@Override
	public void onSuspended(CoronaRuntime runtime) {
	}

	@Override
	public void onResumed(CoronaRuntime runtime) {
	}

	@Override
	public void onExiting(CoronaRuntime runtime) {
		// Remove the Lua listener reference.
		CoronaLua.deleteRef( runtime.getLuaState(), fListener );
		fListener = CoronaLua.REFNIL;
	}

	public int init(LuaState L) {
		int listenerIndex = 1;

		if(_beacons == null)
			_beacons = new ArrayList<IBeacon>();

		_ibp = IBeaconProtocol.getInstance(activity);
		_ibp.setListener(this);


		if ( CoronaLua.isListener( L, listenerIndex, EVENT_NAME ) ) {
			fListener = CoronaLua.newRef( L, listenerIndex );
		}

		final String message = "ibeacon intialised";
		final boolean intialised = true;


		com.ansca.corona.CoronaRuntimeTask task = new com.ansca.corona.CoronaRuntimeTask() {
			@Override
			public void executeUsing(com.ansca.corona.CoronaRuntime runtime) {
				// Create a Lua table for storing the response.
				com.naef.jnlua.LuaState luaState = runtime.getLuaState();

				try{

					if ( CoronaLua.REFNIL != fListener ) {
						// Setup the event
						CoronaLua.newEvent(luaState, "library");

						luaState.pushString("init");
						luaState.setField( -2, "phase" );

						luaState.pushBoolean(intialised );
						luaState.setField( -2, "initialised" );

						luaState.pushString(message );
						luaState.setField( -2, "message" );


						// Dispatch the event
						CoronaLua.dispatchEvent( luaState, fListener, 0 );
					}
				}
				catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		};

		myRuntimeTaskDispatcher.send(task);

		return 0;
	}


	public int scan(LuaState L) {
		int listenerIndex = 1;

		scanBeacons();

		if ( CoronaLua.isListener( L, listenerIndex, EVENT_NAME ) ) {
			fListener = CoronaLua.newRef( L, listenerIndex );
		}


		final String message = "Scanning Started";
		final boolean isScanning = _ibp.isScanning();

		com.ansca.corona.CoronaRuntimeTask task = new com.ansca.corona.CoronaRuntimeTask() {
			@Override
			public void executeUsing(com.ansca.corona.CoronaRuntime runtime) {
				// Create a Lua table for storing the response.
				com.naef.jnlua.LuaState luaState = runtime.getLuaState();

				try{

					if (CoronaLua.REFNIL != fListener ) {
						// Setup the event
						CoronaLua.newEvent( luaState, "library" );

						luaState.pushString("scan" );
						luaState.setField( -2, "phase" );

						luaState.pushBoolean(isScanning);
						luaState.setField( -2, "scanning" );

						luaState.pushString( message );
						luaState.setField( -2, "message" );


						// Dispatch the event
						CoronaLua.dispatchEvent( luaState, fListener, 0 );
					}
				}
				catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		};

		myRuntimeTaskDispatcher.send(task);

		return 0;
	}

	public int stopscanning(LuaState L) {
		int listenerIndex = 1;


		if (_ibp.isScanning())
			_ibp.stopScan();

		_ibp.stopScan();

		Log.i(Utils.LOG_TAG, "Stopped scan");

		if ( CoronaLua.isListener( L, listenerIndex, EVENT_NAME ) ) {
			fListener = CoronaLua.newRef( L, listenerIndex );
		}


		final String message = "Scanning Stopped";
		final boolean isScanning = _ibp.isScanning();


		com.ansca.corona.CoronaRuntimeTask task = new com.ansca.corona.CoronaRuntimeTask() {
			@Override
			public void executeUsing(com.ansca.corona.CoronaRuntime runtime) {
				// Create a Lua table for storing the response.
				com.naef.jnlua.LuaState luaState = runtime.getLuaState();

				try{

					if ( CoronaLua.REFNIL != fListener ) {
						// Setup the event
						CoronaLua.newEvent(luaState, "library" );

						luaState.pushString( "stopscan" );
						luaState.setField( -2, "phase" );

						luaState.pushBoolean( isScanning);
						luaState.setField( -2, "scanning" );

						luaState.pushString( message );
						luaState.setField( -2, "message" );

						// Dispatch the event
						CoronaLua.dispatchEvent( luaState, fListener, 0 );
					}
				}
				catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		};

		myRuntimeTaskDispatcher.send(task);

		return 0;
	}


	public int getbeacons(LuaState L) {
		int listenerIndex = 1;

		if(_beacons == null)
			_beacons = new ArrayList<IBeacon>();

		Log.i(Utils.LOG_TAG, "Get Beacons");

		if ( CoronaLua.isListener( L, listenerIndex, EVENT_NAME ) ) {
			fListener = CoronaLua.newRef( L, listenerIndex );
		}


		final String myString = "Stopping Scan";
		final int myInt = 57;
		final boolean myBool = true;



		com.ansca.corona.CoronaRuntimeTask task = new com.ansca.corona.CoronaRuntimeTask() {
			@Override
			public void executeUsing(com.ansca.corona.CoronaRuntime runtime) {
				// Create a Lua table for storing the response.
				com.naef.jnlua.LuaState luaState = runtime.getLuaState();

				try{

					if ( CoronaLua.REFNIL != fListener ) {
						// Setup the event
						CoronaLua.newEvent( luaState, "library" );

						// Push the "name" field.
						luaState.pushString("getBeacons");
						luaState.setField(-2, "phase");

						// Push the "id" field.
						luaState.pushInteger(12345);
						luaState.setField(-2, "id");

						// Push all achievement information as a Lua array under the "data" field.
						int index = 1;
						luaState.newTable(0, 0);
						int luaTableStackIndex = luaState.getTop();

						for (IBeacon item : _beacons) {
								Log.i(Utils.LOG_TAG, "GET Beacon - UUID: " + item.getUuidHexStringDashed());
								Log.i(Utils.LOG_TAG, "GET Beacon - Major: " + item.getMajor() + " Minor: " + item.getMinor() + " Distance: " + item.getProximity() + "m.");
								luaState.newTable(0, 0);                                                    //data[1], data[2], etc
								luaState.pushString(item.getUuidHexStringDashed());
								luaState.setField(-2, "UUID");
								luaState.pushInteger(item.getMajor());
								luaState.setField(-2, "Major");
								luaState.pushInteger(item.getMinor());
								luaState.setField(-2, "Minor");
								luaState.pushInteger(item.getProximity());
								luaState.setField(-2, "Distance");
								luaState.rawSet(luaTableStackIndex, index);
								index++;

						}
						luaState.setField(-2, "data");

						luaState.pushInteger(index-1);
						luaState.setField(-2, "count");


						// Dispatch the event
						CoronaLua.dispatchEvent( luaState, fListener, 0 );
					}
				}
				catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		};

		myRuntimeTaskDispatcher.send(task);

		return 0;
	}


	/** Implements the library.init() Lua function. */
	private class InitWrapper implements NamedJavaFunction {

		@Override
		public String getName() {
			return "init";
		}

		@Override
		public int invoke(LuaState L) {
			return init(L);
		}
	}


	/** Implements the library.scan() Lua function. */
	private class ScanWrapper implements NamedJavaFunction {

		@Override
		public String getName() {
			return "scan";
		}

		@Override
		public int invoke(LuaState L) {
			return scan(L);
		}
	}


	/** Implements the library.stopscan() Lua function. */
	private class StopWrapper implements NamedJavaFunction {

		@Override
		public String getName() {
			return "stopscan";
		}

		@Override
		public int invoke(LuaState L) {
			return stopscanning(L);
		}
	}

	/** Implements the library.getbeacons() Lua function. */
	private class GetBeaconsWrapper implements NamedJavaFunction {

		@Override
		public String getName() {
			return "getBeacons";
		}

		@Override
		public int invoke(LuaState L) {
			return  getbeacons(L);
		}
	}


	public void showYourActivity() {
		// Fetch the active Corona activity.
		CoronaActivity activity = CoronaEnvironment.getCoronaActivity();
		if (activity == null) {
			return;
		}

		// Register your activity handler.
		int requestCode = activity.registerActivityResultHandler(new MyHandler());

		// Launch your intent with the above request code.
		Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
		activity.startActivityForResult(enableBtIntent, requestCode);
	}

	private static class MyHandler implements CoronaActivity.OnActivityResultHandler {
		public MyHandler() {}

		@Override
		public void onHandleActivityResult(
				CoronaActivity activity, int requestCode, int resultCode, android.content.Intent data)
		{
			// Unregister this handler.
			activity.unregisterActivityResultHandler(this);

			// Handle the result...
		}
	}


	private void scanBeacons(){
		// Check Bluetooth every time
		Log.i(Utils.LOG_TAG,"Scanning for beacons");

		// Filter based on default easiBeacon UUID, remove if not required
		//_ibp.setScanUUID(UUID here);

		final CoronaActivity activity = CoronaEnvironment.getCoronaActivity();
		// Create a new runnable object to invoke our activity

				if (!IBeaconProtocol.configureBluetoothAdapter(activity)) {
					Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
					Log.i(Utils.LOG_TAG,"Requesting Bleutooth Enable");
					showYourActivity();
				} else {
					if (_ibp.isScanning())
						_ibp.stopScan();

					Log.i(Utils.LOG_TAG,"Starting scan");

					_beacons.clear();

					_ibp.reset();
					_ibp.startScan();
				}
	}


	// The following methods implement the IBeaconListener interface

	@Override
	public void beaconFound(IBeacon ibeacon) {
		_beacons.add(ibeacon);
		Log.i(Utils.LOG_TAG,ibeacon.getUuidHexStringDashed());
		Log.i(Utils.LOG_TAG, "Major: " + ibeacon.getMajor() + " Minor: " + ibeacon.getMinor() + " Distance: " + ibeacon.getProximity() + "m.");
		Log.i(Utils.LOG_TAG, "Beacon Found");
	}

	@Override
	public void enterRegion(IBeacon ibeacon) {
		// TODO Auto-generated method stub
		Log.i(Utils.LOG_TAG, "Enter Region");
	}

	@Override
	public void exitRegion(IBeacon ibeacon) {
		// TODO Auto-generated method stub
		Log.i(Utils.LOG_TAG, "Exit Region");
	}

	@Override
	public void operationError(int status) {
		Log.i(Utils.LOG_TAG, "Bluetooth error: " + status);

	}

	@Override
	public void searchState(int state) {
		if(state == IBeaconProtocol.SEARCH_STARTED){
			//startRefreshAnimation();
		}else if (state == IBeaconProtocol.SEARCH_END_EMPTY || state == IBeaconProtocol.SEARCH_END_SUCCESS){
			//stopRefreshAnimation();
		}
	}
}
