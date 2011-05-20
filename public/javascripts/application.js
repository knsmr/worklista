$(function() {

    $('.item')
	.live('mouseenter', function(){
	    $(this).css('background', '#ccffff')
	})
	.live("mouseleave", function(){
	    $(this).css('background', '#eeffff')
	});

    $('.button').button();
    $('#menu-navi ul li a').button();
    $('#item-tab ul li a').button();
    $('#item-tab .selected a').css('background', '#ccffff').css('border-bottom', 'none');
    $('.tag_link').button();

// This isn't working correctly. We need to insert the form for each
// item for this to work. 
//    $('input').filter('.datepicker').datepicker(
//	{dateFormat: 'yy-mm-dd'});
//		     startDate: '01/01/1970',
//		     endDate: (new Date()).asString()});

    var showEditbuttons = function(){
	$('.edit-buttons .item_delete').button({icons:{primary:'ui-icon-trash'}});
	$('.edit-buttons .item_edit').button({icons:{primary:'ui-icon-pencil'}});
	$('.edit-buttons .item_pick').button({icons:{primary:'ui-icon-star'}});
	$('.edit-buttons .item_unpick').button({icons:{primary:'ui-icon-close'}});

	$('.edit-buttons').each(function(){
	    var $editButton = $(this).find('.item_edit');
	    var $form = $(this).find('form');
	    $editButton.click(function(){
		$form.dialog({
		    modal: true,
		    show: "fade",
		    title: 'Edit item',
		    width: 'auto'
		});

		var $textarea = $form.find('.inline-edit textarea');
		var $tags = $form.find('.inline-edit #item_tag_names');
		var $counter = $textarea.next();
		var $submit = $form.find('#item_submit');
		var $counterColor = $counter.css('color');
		var $update_count = function(){
		    var $charLength = $textarea.val().length;
		    $counter.text($charLength+'/400');
		    if ($charLength > 400) {
			$counter.css('color', 'red');
			$submit.attr('disabled', 'disabled');
		    } else {
			$counter.css('color', $counterColor);
			$submit.removeAttr('disabled');
		    }
		}
		$update_count();
		$tags.focus();
		$textarea.keyup(function(){
		    $update_count();
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
	    $('.edit-buttons').first().find('.item_edit').click();
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
