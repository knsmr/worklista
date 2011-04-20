$(function() {
    $('#url-form form input[type=text]').focus();

    $('.item').hover(
	function(){$(this).css('background', '#dfffff')},
	function(){$(this).css('background', '#f3ffff')}
    );
});
