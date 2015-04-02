CKEDITOR.editorConfig = function( config ) {

  config.language = 'en';

  config.filebrowserBrowseUrl = "/ckeditor/attachment_files";
  config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";
  config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";
  config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";
  config.filebrowserImageBrowseUrl = "/ckeditor/pictures";
  config.filebrowserImageUploadUrl = "/ckeditor/pictures";
  config.filebrowserUploadUrl = "/ckeditor/attachment_files";

  // Make dialogs simpler.
  config.removeDialogTabs = 'image:advanced;image:Link;link:advanced;link:upload';
  config.linkShowTargetTab = true;

  // In CKEditor 4.1 or higher you need to disable ACF (Advanced Content Filter)
  // to make Youtube plugin work:
  config.allowedContent = true;

  /* Toolbars */
  config.toolbar = 'mini';

  config.toolbar_mini =
    [
      ['Source','-','Preview'],
      ['Cut','Copy','Paste','PasteText','PasteFromWord'],
      ['Undo','Redo','-','RemoveFormat'],
      [ 'Find','Replace','-','SelectAll','-','Scayt' ],
      ['Bold','Italic','Underline','Strike'], ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
      ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
      ['Link','Unlink','Anchor'], ['Attachment'], ['Youtube'],
      ['Image', 'Table','HorizontalRule','PageBreak'],
      ['Format']
    ];

  // Rails CSRF token
  config.filebrowserParams = function(){
    var csrf_token, csrf_param, meta,
        metas = document.getElementsByTagName('meta'),
        params = new Object();

    for ( var i = 0 ; i < metas.length ; i++ ){
      meta = metas[i];

      switch(meta.name) {
        case "csrf-token":
          csrf_token = meta.content;
          break;
        case "csrf-param":
          csrf_param = meta.content;
          break;
        default:
          continue;
      }
    }

    if (csrf_param !== undefined && csrf_token !== undefined) {
      params[csrf_param] = csrf_token;
    }

    return params;
  };

  config.addQueryString = function( url, params ){
    var queryString = [];

    if ( !params ) {
      return url;
    } else {
      for ( var i in params )
        queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
    }

    return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
  };

  // Integrate Rails CSRF token into file upload dialogs (link, image, attachment and flash)
  CKEDITOR.on( 'dialogDefinition', function( ev ){
    // Take the dialog name and its definition from the event data.
    var dialogName = ev.data.name;
    var dialogDefinition = ev.data.definition;
    var content, upload;

    if (CKEDITOR.tools.indexOf(['link', 'image', 'attachment', 'flash'], dialogName) > -1) {
      content = (dialogDefinition.getContents('Upload') || dialogDefinition.getContents('upload'));
      upload = (content == null ? null : content.get('upload'));

      if (upload && upload.filebrowser && upload.filebrowser['params'] === undefined) {
        upload.filebrowser['params'] = config.filebrowserParams();
        upload.action = config.addQueryString(upload.action, upload.filebrowser['params']);
      }
    }


    if (dialogName == 'link') {
      // Remove the 'Upload' and 'Advanced' tabs from the 'Link' dialog.
      // dialogDefinition.removeContents('upload');
      // dialogDefinition.removeContents('advanced');

      // Get a reference to the 'Link Info' tab.
      var infoTab = dialogDefinition.getContents('info');
      // Remove unnecessary widgets from the 'Link Info' tab.
      infoTab.remove('linkType');
      infoTab.remove('protocol');
      infoTab.remove('browse');

      // Get a reference to the "Target" tab and set default to '_blank'
      var targetTab = dialogDefinition.getContents('target');
      var targetField = targetTab.get('linkTargetType');
      targetField['default'] = '_blank';

    } else if (dialogName == 'image') {
      // Remove the 'Link' and 'Advanced' tabs from the 'Image' dialog.
      // dialogDefinition.removeContents('Link');
      // dialogDefinition.removeContents('advanced');

      // Get a reference to the 'Image Info' tab.
      var infoTab = dialogDefinition.getContents('info');
      // Remove unnecessary widgets/elements from the 'Image Info' tab.
      infoTab.remove('browse');
      infoTab.remove('txtHSpace');
      infoTab.remove('txtVSpace');
      infoTab.remove('txtBorder');
      // infoTab.remove('cmbAlign');
    }


  });
};
