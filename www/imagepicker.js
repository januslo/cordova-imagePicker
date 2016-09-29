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
*       .localization - the localization messages with keys: ok, discard,chooser_name,free_version_label,error_database,requesting_thumbnails,processing_images_header,processing_images_message,maximum_selection_count_error_header,maximum_selection_count_error_message
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
		localization:options.localization?options.localization:{
			ok:"OK",
			discard:"Cancel",
			chooser_name:"MultiImageChooser",
			free_version_label:"Free version - Images left: %d",
			error_database:"There was an error opening the images database. Please report the problem.",
			requesting_thumbnails:"Requesting thumbnails, please be patient",
			processing_images_header:"Processing Images",
			processing_images_message:"This may take a few moments",
			maximum_selection_count_error_header:"Limit reached",
			maximum_selection_count_error_message:"You can only select %d photos at once."
		}
	};

	return cordova.exec(success, fail, "ImagePicker", "getPictures", [params]);
};

window.imagePicker = new ImagePicker();
