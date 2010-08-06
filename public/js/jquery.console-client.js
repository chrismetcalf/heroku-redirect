/**
 * Convenience functions to call into the Socrata console iframe
 */
(function($){
  $.fn.setupVisor = function($links) {
    var $visor = this;
    // Set up the iframe and associated goodies.
    $visor.append("<iframe src=\"http://www.socrata.com/console.html\" id=\"console\"></iframe>");
    $visor.append("<p><a id=\"close\" href=\"#close\">close console</a>");

    // Set up the close link
    $visor.find("#close").live("click", function(e) {
        e.preventDefault();
        $visor.hide();
      }
    );

    // Hide it
    $visor.hide();

    // Wire up the links
    console = $visor.find("iframe#console")[0].contentWindow;
    $links.live("click", function(e) {
        e.preventDefault();
        $visor.show();
        console.postMessage('socrata-exec:' + $(this).text(), '*');
    });
  }

  $.fn.setupConsole = function($links) {
    // Wire up the links
    $console = this[0].contentWindow;
    $links.live("click", function(e) {
        e.preventDefault();
        $console.postMessage('socrata-exec:' + $(this).text(), '*');
    });
  }
}) (jQuery);


