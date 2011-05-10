$(function() {

    $('.item')
	.live('mouseenter', function(){
	    $(this).css('background', '#ccffff')
	})
	.live("mouseleave", function(){
	    $(this).css('background', '#f3ffff')
	});

    $('ul li.button').button().css({'background': '#cbedff', 'font-size': '1.4em'});
    $('ul li.button').button();
    $('#menu-navi ul li a').button();
    $('#item-tab ul li a').button();
    $('#item-tab .selected a').css('background', '#f3ffff').css('border-bottom', 'none');

    var showEditbuttons = function(){
	$('.edit-buttons .item_delete').button({icons:{primary:'ui-icon-trash'}});
	$('.edit-buttons .item_edit').button({icons:{primary:'ui-icon-pencil'}});
	$('.edit-buttons .item_pick').button({icons:{primary:'ui-icon-star'}});
	$('.edit-buttons .item_unpick').button({icons:{primary:'ui-icon-close'}});

	$('.edit-buttons').find('#item_published_at').datepicker({dateFormat: 'yy-mm-dd'});
	$('.edit-buttons').each(function(){
	    var $editButton = $(this).find('.item_edit');
	    var $form = $(this).find('form');
	    $form.css('display', 'none');
	    $editButton.click(function(){
		$form.dialog({
		    modal: true,
		    title: 'Edit item',
		    width: 'auto'
		});
	    });
	});
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
	    $('#url-form input[type=text]').val("");
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
		    .css('padding', '30px 15px');
	    }
	});

});
