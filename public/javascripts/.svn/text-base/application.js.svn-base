// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var Application =  {
  lastId: 0,
  currentSampleNb: 0,

  getNewId: function() {
    Application.lastId++;
    return "window_id_" + Application.lastId;
  },

	debug: function() {
		Ajax.Responders.register({
			// log the beginning of the requests
			onCreate: function(request, transport) {
				new Insertion.Bottom('debug', '<p><strong>[' + new Date().toString() + '] accessing ' + request.url + '</strong></p>')
			},

			// log the completion of the requests
			onComplete: function(request, transport) {
				new Insertion.Bottom('debug',
				'<p><strong>http status: ' + transport.status + '</strong></p>' +
				'<pre>' + transport.responseText.escapeHTML() + '</pre>')
			}
		});
	}
}

function ajaxWindow(title, url, width, height) {
	var win = new Window(Application.getNewId(), {className: "dialog", width: width,
			height: height, zIndex: 100, resizable: true, title: title,
			maximizable: false, minimizable: false, draggable: true, 
			showEffectOptions: {duration:0.5},
			wiredDrag: true});
	win.setDestroyOnClose();
	win.setAjaxContent(url, 
			{method: "get"}, true, true);
}
