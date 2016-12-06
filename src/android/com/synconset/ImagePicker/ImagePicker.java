/**
 * An Image Picker Plugin for Cordova/PhoneGap.
 */
package com.synconset;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

public class ImagePicker extends CordovaPlugin {
	public static String TAG = "ImagePicker";
    public static final String LOCALIZATION_OK="ok";
    public static final String LOCALIZATION_DISCARD="discard";
    public static final String LOCALIZATION_MULTY_CHOOSER_NAME="multy_chooser_name";
    public static final String LOCALIZATION_SINGLE_CHOOSER_NAME="single_chooser_name";
    public static final String LOCALIZATION_LOADING_NAME="loading_name";
    public static final String LOCALIZATION_FREE_VERSION="free_version_label";
    public static final String LOCALIZATION_ERROR_DATABASE="error_database";
    public static final String LOCALIZATION_REQUESTING_THUMBNAILS="requesting_thumbnails";
    public static final String LOCALIZATION_PROCESSING_IMAGES_HEADER="processing_images_header";
    public static final String LOCALIZATION_PROCESSING_IMAGES_MESSAGE="processing_images_message";
    public static final String LOCALIZATION_MAXIMUM_SELECTION_COUNT_HEADER="maximum_selection_count_error_header";
    public static final String LOCALIZATION_MAXIMUM_SELECTION_COUNT_MSG="maximum_selection_count_error_message";
    public static final String LOCALZITION_SQUARE="square";
	 
	private CallbackContext callbackContext;
	private JSONObject params;
	 
	public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
		 this.callbackContext = callbackContext;
		 this.params = args.getJSONObject(0);
		if (action.equals("getPictures")) {
			Intent intent = new Intent(cordova.getActivity(), MultiImageChooserActivity.class);
			int max = 20;
			int desiredWidth = 0;
			int desiredHeight = 0;
			int quality = 100;
            JSONObject localization=null;
			if (this.params.has("maximumImagesCount")) {
				max = this.params.getInt("maximumImagesCount");
			}
			if (this.params.has("width")) {
				desiredWidth = this.params.getInt("width");
			}
			if (this.params.has("height")) {
				desiredHeight = this.params.getInt("height");
			}
			if (this.params.has("quality")) {
				quality = this.params.getInt("quality");
			}
            intent.putExtra("MAX_IMAGES", max);
			intent.putExtra("WIDTH", desiredWidth);
			intent.putExtra("HEIGHT", desiredHeight);
			intent.putExtra("QUALITY", quality);
            intent.putExtra(LOCALIZATION_OK,this.params.has(LOCALIZATION_OK)?this.params.getString(LOCALIZATION_OK):"");
            intent.putExtra(LOCALIZATION_DISCARD,this.params.has(LOCALIZATION_DISCARD)?this.params.getString(LOCALIZATION_DISCARD):"");
            intent.putExtra(LOCALIZATION_MULTY_CHOOSER_NAME,this.params.has(LOCALIZATION_MULTY_CHOOSER_NAME)?this.params.getString(LOCALIZATION_MULTY_CHOOSER_NAME):"");
            intent.putExtra(LOCALIZATION_SINGLE_CHOOSER_NAME,this.params.has(LOCALIZATION_SINGLE_CHOOSER_NAME)?this.params.getString(LOCALIZATION_SINGLE_CHOOSER_NAME):"");
            intent.putExtra(LOCALIZATION_LOADING_NAME,this.params.has(LOCALIZATION_LOADING_NAME)?this.params.getString(LOCALIZATION_LOADING_NAME):"");
            intent.putExtra(LOCALIZATION_FREE_VERSION,this.params.has(LOCALIZATION_FREE_VERSION)?this.params.getString(LOCALIZATION_FREE_VERSION):"");
            intent.putExtra(LOCALIZATION_ERROR_DATABASE,this.params.has(LOCALIZATION_ERROR_DATABASE)?this.params.getString(LOCALIZATION_ERROR_DATABASE):"");
            intent.putExtra(LOCALIZATION_REQUESTING_THUMBNAILS,this.params.has(LOCALIZATION_REQUESTING_THUMBNAILS)?this.params.getString(LOCALIZATION_REQUESTING_THUMBNAILS):"");
            intent.putExtra(LOCALIZATION_PROCESSING_IMAGES_HEADER,this.params.has(LOCALIZATION_PROCESSING_IMAGES_HEADER)?this.params.getString(LOCALIZATION_PROCESSING_IMAGES_HEADER):"");
            intent.putExtra(LOCALIZATION_PROCESSING_IMAGES_MESSAGE,this.params.has(LOCALIZATION_PROCESSING_IMAGES_MESSAGE)?this.params.getString(LOCALIZATION_PROCESSING_IMAGES_MESSAGE):"");
            intent.putExtra(LOCALIZATION_MAXIMUM_SELECTION_COUNT_HEADER,this.params.has(LOCALIZATION_MAXIMUM_SELECTION_COUNT_HEADER)?this.params.getString(LOCALIZATION_MAXIMUM_SELECTION_COUNT_HEADER):"");
            intent.putExtra(LOCALIZATION_MAXIMUM_SELECTION_COUNT_MSG,this.params.has(LOCALIZATION_MAXIMUM_SELECTION_COUNT_MSG)?this.params.getString(LOCALIZATION_MAXIMUM_SELECTION_COUNT_MSG):"");
              intent.putExtra(LOCALZITION_SQUARE,this.params.has(LOCALZITION_SQUARE)?this.params.getInt(LOCALZITION_SQUARE):0);
            if (this.cordova != null) {
				this.cordova.startActivityForResult((CordovaPlugin) this, intent, 0);
			}
		}
		return true;
	}
	
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == Activity.RESULT_OK && data != null) {
			ArrayList<String> fileNames = data.getStringArrayListExtra("MULTIPLEFILENAMES");
			JSONArray res = new JSONArray(fileNames);
			this.callbackContext.success(res);
		} else if (resultCode == Activity.RESULT_CANCELED && data != null) {
			String error = data.getStringExtra("ERRORMESSAGE");
			this.callbackContext.error(error);
		} else if (resultCode == Activity.RESULT_CANCELED) {
			JSONArray res = new JSONArray();
			this.callbackContext.success(res);
		} else {
			this.callbackContext.error("No images selected");
		}
	}
}
