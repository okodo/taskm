$(document).on('click', 'a.destroy-entry', function(e){
  if(typeof($(this).data('uid')) !== 'undefined'){
    e.preventDefault();
    turbo_loader("show");
    $.ajax({
      type: 'DELETE',
      url: "/users/"+$(this).data('uid'),
      success: function(response){
        turbo_loader("hide");
        window.location.reload();
      }
    })
  }
})
