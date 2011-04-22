$(function() {

    $('.item')
	.live('mouseenter', function(){
	    $(this).css('background', '#ddffff')
	})
	.live("mouseleave", function(){
	    $(this).css('background', '#f3ffff')
	});


    var showEditbuttons = function(){
	$('#edit-buttons .item_delete').button({icons:{primary:'ui-icon-trash'}});
	$('#edit-buttons .item_edit').button({icons:{primary:'ui-icon-pencil'}});
	$('#edit-buttons .item_pick').button({icons:{primary:'ui-icon-star'}});
	$('#edit-buttons .item_unpick').button({icons:{primary:'ui-icon-close'}});
    };

    showEditbuttons();

    $('#url_form')
	.live("ajax:beforeSend", function(evt, xhr, settings){
	    if (($('input[type=text]').val() == "http://...") ||
		($('input[type=text]').val() == "")) { return false; };

	    $('input[name=commit]').attr('disabled', 'disabled');
	    $('input[type=text]').css('color', '#888888').attr('disabled', 'disabled');
	    $(".item:first").before('<div class="item" id="new_item"><img src="/images/ajax-loader.gif"></div>');
	})
	.live("ajax:success", function(evt, data, status, xhr){
	    $("#new_item").remove();
	    $(".item:first").before(xhr.responseText);
	    showEditbuttons();
	    $('input[type=text]').val("");
	})
    	.live('ajax:complete', function(evn, xhr, status){
	    $('input[name=commit]').removeAttr('disabled');
	    $('input[type=text]').removeAttr('disabled').css('color', 'black');
	})
	.live('ajax:error', function(evn, xhr, status, error){    
	    $("#new_item").hide(500, function(){$(this).remove();});
	    $('input[type=text]').removeAttr('disabled');
	    errorText = "Error: " + xhr.responseText;
	    $('#error-message').html(errorText).dialog({buttons: {"OK": function() { $(this).dialog("close");}}});
	});

    $('#url_form input[type=text]')
	.css('color', '#888888').val("http://...")
	.click(function(){
	    if($(this).val() == "http://...") {
		$(this).css('color', 'black').val("")
		    .css('padding', '15px 10px');
	    }
	});

    $('#item_published_at').datepicker({dateFormat: 'yy-mm-dd'});

});
