TUDU.calendar = {
    eventsJSON: [], // Properly formatted JSON array of events for the FullCalendar plugin
    tasksJSON: [], // Properly formatted JSON array of events for the FullCalendar plugin

    /* @function: init
     * GET request to 'users/$user_id/schedule' with auth_token
     * 
     * @param: NONE
     * @return: NONE
     *
     * Sends GET request and parses JSON
     * Immediately invokes @function: index so that the FullCalendar plugin is initizalized
     * synchronously after JSON response
     */
    init: function () {
        $.getJSON(Routes.user_schedule_path(10, {format:'json'}), function (data) {
            // console.log(data.events);
            TUDU.calendar.eventsJSON = UTIL.refactorJSON(data.events);
            console.log(data.tasks);
            TUDU.calendar.tasksJSON = UTIL.refactorJSON(data.tasks);
            // console.log(TUDU.calendar.calendarJSON);
        }).done( TUDU.calendar.index ); // @function: index is invoked synchronously
    },

    /* @function: index
     * Initializes FullCalendar plugin with proper formatting and data
     *
     * @param: NONE
     * @return: NONE
     *
     * When HTML calendar element has loaded, invoke plugin initalizer
     */
    index: function () {
        $("#calendar").ready(function () {
            return $('#calendar').fullCalendar({
                editable: true,
                header: { // Determines what elements to display on calendar header
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                },
                defaultView: 'month',
                height: 500, // In px
                slotMinutes: 30,
                eventSources: [
                    TUDU.calendar.eventsJSON, // array 
                    TUDU.calendar.tasksJSON // array
                ],
                timeFormat: 'h:mm t{ - h:mm t} ',
                dragOpacity: "0.5",
                eventClick: function (calendarEvent) {
                    TUDU.calendar.Utils.showEvent(calendarEvent);
                },
                eventDrop: function (calendarEvent, dayDelta, minuteDelta, allDay, revertFunc) {
                    TUDU.calendar.Utils.updateEvent(calendarEvent, dayDelta, minuteDelta, allDay, revertFunc);
                },
                eventResize: function (calendarEvent, dayDelta, minuteDelta, revertFunc) {
                    TUDU.calendar.Utils.updateEvent(calendarEvent, dayDelta, minuteDelta, allDay, revertFunc);
                }
            });
        });
        $(document).ready(function () {
            TUDU.calendar.bindEventListeners();
        });
    },

    /* @function: bindEventListeners
     * Binds form submission listeners to new event/task forms
     *
     * @param: NONE
     * @param: NONE
     *
     * ATTN: Needs documentation
     */
    bindEventListeners: function () {
        $('.fc-event').on('click', function () {
            var $this = $(this);
            var $showEvent = $('#showEvent');

            var x = $this.offset().left + $this.width() + "px";
            var y = $this.offset().top + "px";

            $showEvent.ready(function () {
                $showEvent.css("left", x);
                $showEvent.css("top", y);
            });
        });

        $('#calendar').on('click', '#closeEvent', function () {
            $('#showEvent').remove();
        });
    },

    Utils: {
        showEvent: function (calendarEvent) {
            $('#showEvent').remove();
            console.log(calendarEvent);
            var templateString = $('#show-event-template').html();
            var templateFunction = Handlebars.compile(templateString);
            var htmlWithData = templateFunction(calendarEvent);
            $('#calendar').append(htmlWithData);
        },

        updateEvent: function (calendarEvent, dayDelta, minuteDelta, allDay, revertFunc) {
            var start = calendarEvent.start;
            var end = calendarEvent.end;

            start.setMinutes(start.getMinutes() + minuteDelta);
            start.setDate(start.getDate() + dayDelta);
            end.setMinutes(end.getMinutes() + minuteDelta);
            end.setDate(end.getDate() + dayDelta);

            calendarEvent.allDay = allDay;

            var url = Routes.user_event_path(3, calendarEvent.id);
            var event = UTIL.unrefactorJSON(calendarEvent);
            // debugger;
            $.ajax({
                url: url,
                type: "PATCH",
                data: event,
                dataType: "json"
            });
        }
    }
};
