/**
 * Convenience functions to call into the Socrata console iframe
 */

// Sets up links to make them executable using the console iframe passed in
jQuery.fn.setupExec = function(console) {
  this.live("click", function(e) {
      e.preventDefault();
      console[0].contentWindow.postMessage('socrata-exec:get("' + this + '")', '*');
      console.focus();
  });
}
