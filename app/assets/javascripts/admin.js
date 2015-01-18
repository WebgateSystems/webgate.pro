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
    paramName: "screenshots[file][]", // Rails expects the file upload to be something like model[field_name]
    addRemoveLinks: true, // Show remove links on dropzone itself.
    previewsContainer: ".dropzone-previews",
    acceptedFiles: ".png, .jpg",
    autoProcessQueue: false,
    uploadMultiple: true,
    forceFallback: false,
    parallelUploads: 10,
    maxFiles: 10
  }); 

  //dropzone.on("success", function(file) {
  //  this.removeFile(file)
  //  $.getScript("/projects")
  //})
});