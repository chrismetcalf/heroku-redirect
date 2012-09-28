(function($){
  $.fn.setupVisor = function(links) {
    var visor = this;

    // Set up the placeholder for the iframe and associated goodies.
    visor.append('<iframe seamless="seamless" frameborder="0" id="tester" width="790" height="630"></iframe>');
    visor.append('<p><a id="close" href="#close">close</a></p>');

    // Hide it by default
    visor.hide();

    // Show the Visor
    var showVisor = function(onShown) {
      visor.show();
      visor.css('top', -1 * visor.outerHeight(true));
      visor.animate({ top: 0 }, function() {
        if (onShown !== undefined) {
          onShown();
        }
      });
    };

    // Hide the visor
    var hideVisor = function() {
      visor.animate({ top: -1 * visor.outerHeight(true) }, function() { $(this).hide(); });
    };

    // Set up the close link
    visor.find("#close").click(function(e) {
      e.preventDefault();
      hideVisor();
    });

    // Wire up the links
    links.click(function(event) {
      event.preventDefault();
      var link = $(this);

      // Figure out what URL to use for live-docs
      // var match = link.text().match("http://([^/]+)/resource/(.+)$");
      var match = link.text().match('http://([^/]+)/resource/([^.]+).json(.*)$');
      if(match) {
        showVisor(function() {
          $("iframe#tester").attr("src", "http://live-docs.socrata.com/" + match[1] + "/inline/" + match[2] + match[3]);
        });
      } else {
        // If it's not JSON, we should do something with it
        window.open(link.attr("href"));
      }
    });
  };

  // Set up the visor and links
  $("#visor").setupVisor($('a[href*="soda.demo.socrata.com"][href*=json]'));
  $('a[href*="soda.demo.socrata.com"][href*=json]').addClass("exec");
}) (jQuery);


