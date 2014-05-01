TUDU.home = {
	todayJSON: [], // Properly formatted JSON array of events for the FullCalendar plugin

	/* @function: init
     * GET request to 'users/$user_id/schedule' with auth_token
     * 
     * @param: NONE
     * @return: NONE
     *
     * Sends GET request and parses JSON
     * Immediately invokes @function: index so that the FullCalendar
     * plugin is initizalized synchronously after JSON response
     */
    init: function () {
        var lala = [];
        $.when(
            $.getJSON(Routes.today_events_path(), function (data) {
                TUDU.home.todayJSON = TUDU.home.todayJSON.concat(UTIL.refactorJSON(data));
            })
            // ,
            // $.post(Routes.schedule_tasks_path(), function (data) {
            //     // console.log(data);
            //     TUDU.home.todayJSON = TUDU.home.todayJSON.concat(UTIL.refactorJSON(data));
            // })
        ).done( TUDU.home.index ); // @function: index is invoked synchronously after JSON has loaded
    },

    /* @function: index
     * Initializes FullCalendar plugin with proper formatting and data,
     * loads same data into Handlebars template
     *
     * @param: NONE
     * @return: NONE
     *
     * When HTML calendar element has loaded, invoke plugin initalizer
     */
    index: function () {
        console.log(TUDU.home.todayJSON);
    	// FullCalendar initialization
        $("#today").ready(function () {
            return $('#today').fullCalendar({
            	header: {
            		left: '',
            		center: 'title',
            		right: ''
            	},
                defaultView: 'agendaDay',
                height: 700, // In px
                slotMinutes: 30,
                events: TUDU.home.todayJSON, // JSON array 
                timeFormat: 'h:mm t{ - h:mm t}'
            });
        });

        // Handlebars initialization
        var templateString = $('#schedule-template').html();
        var templateFunction = Handlebars.compile(templateString);
        var $list = $('#list_events');
        $.each(TUDU.home.todayJSON, function (i, event) {
        	event.startFormatted = moment(event.start).format("h:mm A");
            event.endFormatted = moment(event.end).format("h:mm A");
        	var htmlWithData = templateFunction(event);
        	$list.append(htmlWithData);
        });
    }
};