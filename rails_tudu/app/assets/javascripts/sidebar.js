TUDU.sidebar = {

	/* @function: init
	 * Initializes datepickers and sliders for event/task input
	 * 
	 * @param: NONE
	 * @return: NONE
	 *
	 * Invokes @function: bindEventListeners
	 */
	init: function () {
		$(document).ready( function() {
			var datetimeoptions = {
				minuteStepping: 5
			};
			$('#start_time_picker').datetimepicker( datetimeoptions );
			$('#end_time_picker').datetimepicker( datetimeoptions );
			$('#deadline_picker').datetimepicker( datetimeoptions );
			$('#duration_slider').slider({
				slide: function( event, ui ) {},
				min: 15,
				step: 15
			});
			TUDU.sidebar.bindEventListeners();
			$('#new_task').hide();
		} );
	},

	/* @function: bindEventListeners
	 * Binds form submission listeners to new event/task forms
	 *
	 * @param: NONE
	 * @param: NONE
	 *
	 * ATTN: Needs documentation and refactoring 
	 * (too many listeners, class names need renaming)
	 */
	 bindEventListeners: function () {
	 	$(document).on('submit', '#new_event', function () {
	 		var $this = $(this);
			var date = $this.find('#start_time_picker').data('DateTimePicker').getDate();
			console.log(date);
			$('#start_time_picker').val(date._d);
			date = $this.find('#end_time_picker').data('DateTimePicker').getDate();
			$('#end_time_picker').val(date._d);
	    });

	    $(document).on('submit', '#new_task', function (event) {
			var date = $(this).find('#deadline_picker').data('DateTimePicker').getDate();
			$('#deadline_picker').val(date._d);
	    });

	    $('button#switchForm').on('click', function () {
	    	$('#new_task').toggle();
	    	$('#new_event').toggle();
	    });
	    
	    $('#duration_slider').on('slide', function ( event, ui ) {
	    	$('#duration_value').html(ui.value + "m");
	    	$('#task_duration').attr('value', ui.value*60);
	    });
	 }
};
