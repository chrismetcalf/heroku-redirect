/**
 * Convenience functions to call into the Socrata console iframe
 */
(function($){
  $.fn.setupVisor = function($links) {
    var $visor = this;

    // Set up the iframe and associated goodies.
    $visor.append("<iframe src=\"/console.html\" id=\"console\"></iframe>");
    $visor.append("<p><a id=\"close\" href=\"#close\">close console</a>");

    // Hide it by default
    $visor.hide();


    // Show/hide console helper functions
    var showVisor = function(onShown) {
        $visor.show();
        $visor.css('top', -1 * $visor.outerHeight(true));
        $visor.animate({ top: 0 }, function()
        {
            if (onShown !== undefined)
                onShown();
        });
    };
    var hideVisor = function() {
        $visor.animate({ top: -1 * $visor.outerHeight(true) }, function() { $(this).hide(); });
    };

    // Set up the close link
    $visor.find("#close").live("click", function(e) {
        e.preventDefault();
        hideVisor();
    });

    // Wire up the links
    var console = $visor.find("iframe#console")[0].contentWindow;
    $links.live("click", function(event)
    {
        event.preventDefault();
        var $link = $(this);
        showVisor(function()
        {
            console.postMessage('socrata-exec:' + $link.text(), '*');
        });
    });


    // Easter Egg
    $(document).bind('keydown', function(event)
    {
        if (event.which == 192)
        {
            if ($visor.is(':visible'))
                hideVisor();
            else
                showVisor();
        }
    });
  }

  $.fn.setupConsole = function($links) {
    // Wire up the links
    var console = this[0].contentWindow;
    $links.live("click", function(e) {
        e.preventDefault();
        console.postMessage('socrata-exec:' + $(this).text(), '*');
    });
  }
}) (jQuery);


