
var ready;
ready = function() {
	  $('.sudoku a.cell-value').click(function() {
	  		// console.log($(this).children());
		    $('a.cell-value').removeClass('selected');
		    $("input[type=hidden]").removeClass();
		    $(this).addClass('selected');
		    $(this).children("input").addClass("hidden-selected");
  		});

	  $(".clear-all").click(function() {
	  		$(".filled").each(function(i, obj) {
	  			$(this).removeClass('filled');
	  			$(this).children('span').text('');
	  		});
	  		return false;
	  });
  
        $(document).keypress(function(event){
    		$(".selected span").text(String.fromCharCode(event.which));
    		$(".selected").addClass('filled');  
    		$(".hidden-selected")[0].value = String.fromCharCode(event.which);
 		});

};

$(document).ready(ready);
$(document).on('page:load', ready);