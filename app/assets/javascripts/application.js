/*
 *= require jquery
 *= require jquery-ui
 *= require jquery-ujs
 *= require jquery.turbolinks
 *= require turbolinks
 *= require bootstrap-sass/assets/javascripts/bootstrap-sprockets
 *= require jquery-form
 *= require jquery.cookie
 *= require jquery.easing
 *= require nested_form_fields
 *= require bootstrap-toggle
 *= require select2
 *= require moment
 *= require metisMenu
 *= require startbootstrap-sb-admin-2
 *= require bootstrap-growl/jquery.bootstrap-growl
 *= require_tree .
*/

$(document).on('ready page:load', init_main);
document.addEventListener("page:fetch", function(){ turbo_loader("show"); });
document.addEventListener("page:receive", function(){ turbo_loader("hide"); });

$(document).on("click", "#mobile-sidebar-toggle", function(){ sidebar("toggle"); });

function sidebar(action){
  if(action === "toggle"){
    sidebar($("#sidebar").is(":visible") ? "hide" : "show");
  }else if(action === "show"){
    $("#sidebar").show();
    $("#main").css("margin-left", $("#sidebar").css("width"));
    if($("#sidebar select.select-menu").length > 0) $("#sidebar select.select-menu").select2('destroy').select2();
    if($.inArray($("#mobile-sidebar-toggle").css("content"), ["des", "'des'", "\"des\""]) != -1) $("#mobile-sidebar-toggle").hide();
    $.cookie("sidebar_toggle_taskm", "", { path: '/' });
  }else if(action === "hide"){
    $("#sidebar").hide();
    $("#main").css("margin-left", "0px");
    if(!$("#mobile-sidebar-toggle").is(":visible")) $("#mobile-sidebar-toggle").show();
    $.cookie("sidebar_toggle_taskm", "show", { path: '/' });
  }
}

function init_main(){
  $(document).tooltip({ selector: '[data-toggle="tooltip"]' });
  $("noscript").hide();
  if($("#flash-message-full").length > 0){
    setTimeout(function() {
      $.bootstrapGrowl($("#flash-message-full").text(), {
        ele: 'body',
        type: $("#flash-message-full").data('type'),
        allow_dismiss: true,
        delay: 3000,
        align: 'center',
        width: 400,
        offset: {from: 'top', amount: 100}
      });
    }, 500);
  }
  $(".select-menu").select2();
}

function turbo_loader(action){
  if(action === "hide"){
    $("#turbo-loader").hide();
  }else if(action === "show"){
    $("#turbo-loader").show();
  }
}
