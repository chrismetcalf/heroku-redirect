$(function() {
  // Cute auto-panning for local anchor refs
  $('a[rel=local]').click(function(event) {
    event.preventDefault();
    var $targetElem = $('a[name="' + $(this).attr('href').replace(/^.*#/, '') + '"]');
    var $targetHeader = $targetElem.next('h1,h2,h3,h4,h5,h6');

    $targetHeader.css('background-color', '#ffc000').animate({ 'backgroundColor': '#ffffff' }, 4000);

    $('body').animate({ scrollTop: $targetElem.offset().top }, 2000);
  });

  // Google Code Prettify
  prettyPrint();
});
