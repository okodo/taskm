$(document).on('ready page:load', init_tasks);

$(document).on('click', '.states-events-gr a', function(e){
  e.preventDefault();
  if(!$(this).hasClass('disabled')){
    turbo_loader("show");
    $.ajax({
      type: 'PUT',
      url: "/admin/tasks/"+$(this).data('tid')+"/"+$(this).data('event'),
      success: function(response){
        turbo_loader("hide");
        window.location.reload();
      }
    })
  }
})

function init_tasks(){
  $(".filter-with-select select").change(function(){
    var named = $(this).data("named");
    $("#search-params-container input[type='hidden'][name='"+named+"']").each(function(){ $(this).remove(); });
    if($(this).val() !== ''){
      var hidden_field = "<input id='"+named+"_' type='hidden' value='"+$(this).val()+"' name='"+named+"'>";
      $("#search-params-container").append(hidden_field);
    }
    $("#search-query-lists-form").submit();
  });
}
