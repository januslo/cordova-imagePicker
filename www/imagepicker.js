/*global cordova,window,console*/
/**
 * An Image Picker plugin for Cordova
 * 
 * Developed by Wymsee for Sync OnSet
 */

var ImagePicker = function() {

};

/*
*	success - success callback
*	fail - error callback
*	options
*		.maximumImagesCount - max images to be selected, defaults to 15. If this is set to 1, 
*		                      upon selection of a single image, the plugin will return it.
*		.width - width to resize image to (if one of height/width is 0, will resize to fit the
*		         other while keeping aspect ratio, if both height and width are 0, the full size
*		         image will be returned)
*		.height - height to resize image to
*		.quality - quality of resized image, defaults to 100
*       .ok - the localization text
*       .discard- the localization text
*       .multy_chooser_name- the localization text
*       .single_chooser_name -the localization text
*       .loading_name - the localization text
*       .free_version_label- the localization text
*       .error_database- the localization text
*       .requesting_thumbnails- the localization text
*       .processing_images_header- the localization text
*       .processing_images_message- the localization text
*       .maximum_selection_count_error_header- the localization text
*       .maximum_selection_count_error_message- the localization text
*/
ImagePicker.prototype.getPictures = function(success, fail, options) {
	if (!options) {
		options = {};
	}
	
	var params = {
		maximumImagesCount: options.maximumImagesCount ? options.maximumImagesCount : 15,
		width: options.width ? options.width : 0,
		height: options.height ? options.height : 0,
		quality: options.quality ? options.quality : 100,
		ok: options.ok ? options.ok :"I am not OK",
		discard: options.discard ? options.discard :"Cancel",
		multy_chooser_name: options.multy_chooser_name ? options.multy_chooser_name :"Pick photos",
        single_chooser_name:options.single_chooser_name?options.single_chooser_name:"Pick photo",
        loading_name:options.loading_name?options.loading_name:"Loading",
		free_version_label: options.free_version_label ? options.free_version_label :"Free version",
		error_database: options.error_database ? options.error_database :"There was an error opening the images database. Please report the problem.",
		requesting_thumbnails: options.requesting_thumbnails ? options.requesting_thumbnails :"Requesting thumbnails, please be patient",
		processing_images_header: options.processing_images_header ? options.processing_images_header :"Processing Images",
		processing_images_message: options.processing_images_message ? options.processing_images_message :"This may take a few moments",
		maximum_selection_count_error_header: options.maximum_selection_count_error_header ? options.maximum_selection_count_error_header :"Limit reached",
		maximum_selection_count_error_message: options.maximum_selection_count_error_message ? options.maximum_selection_count_error_message :("You can only select "+(options.maximumImagesCount ? options.maximumImagesCount : 15)+" photos at once."),
		square:(options.square && options.square>0)?options.square:0
	};

	return cordova.exec(success, fail, "ImagePicker", "getPictures", [params]);
};

window.imagePicker = new ImagePicker();
