// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require dropzone

$(function(){ $(document).foundation(); });

$(document).ready(function(){
  // disable auto discover
  Dropzone.autoDiscover = false;
 
  var dropzone = new Dropzone (".dropzone", {
    maxFilesize: 8, // Set the maximum file size to 8 MB
    paramName: "screenshots[file]", // Rails expects the file upload to be something like model[field_name]
    addRemoveLinks: true, // Show remove links on dropzone itself.
    previewsContainer: ".dropzone-previews",
    acceptedFiles: ".png, .jpg",
    autoProcessQueue: false,
    uploadMultiple: true,
    forceFallback: false,
    parallelUploads: 10,
    maxFiles: 10
  });

  $("#submit-all").click(function (e) {
    e.preventDefault();
    e.stopPropagation();
    var form = $(this).closest('#dropzone-form'); //error
    if (form.valid() == true) { 
      if (dropzone.getQueuedFiles().length > 0) {                        
        dropzone.processQueue();  
      } else {                       
        dropzone.uploadFiles([]); //send empty
        //$("#dropzone-form").submit();
      }                                    
    }
    //dropzone.processQueue();
  });

  //dropzone.on("success", function(file) {
  //  this.removeFile(file)
  //  $.getScript("/admin/projects")
  //})

  //dropzone.on("successmultiple", function(files, response) {
  //  window.location.replace(response.redirect);
  //  exit();
  //});
  
  //dropzone.on("errormultiple", function(files, response) {
  //  $("#notifications").before('<div class="alert alert-error" id="alert-error"><button type="button" class="close" data-dismiss="alert">×</button><i class="icon-exclamation-sign"></i> There is a problem with the files being uploaded. Please check the form below.</div>');
  //  exit();
  //});
});