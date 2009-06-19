tinyMCEPopup.requireLangPack();

var SimpleImageDialog = {
	init : function() {
		$('#upload_form').ajaxForm({
			iframe: 'true',
			dataType: 'json',
			success: function(json) {
				var ed = tinyMCEPopup.editor.dom;
				tinyMCEPopup.execCommand('mceInsertContent', false, ed.createHTML('img', {
					id: '__mce_tmp',
					src: json.path }), {skip_undo : 1});
				tinyMCEPopup.close();
			},
			error: function(request, textStatus, errorThrown) {
				alert(request.responseText);
			}
		});
	}
};

tinyMCEPopup.onInit.add(SimpleImageDialog.init, SimpleImageDialog);
