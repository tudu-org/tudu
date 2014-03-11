var updateEvent;
var refactorJSON;
var json = {
  events: {},
  tasks: {}
};

$.when(
  $.getJSON(Routes.events_path(), function(data) {
    refactorJSON(data);
    json.events = data;
  }), 
  $.getJSON(Routes.tasks_path(), function(data) {
    refactorJSON(data);
    json.tasks = data;
  }))
.done(function() {
  $(document).ready(function() {
    var events = json.events.concat(json.tasks);
    return $('#calendar').fullCalendar({
      editable: true,
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
      },
      defaultView: 'month',
      height: 500,
      slotMinutes: 30,
      events: events,
      timeFormat: 'h:mm t{ - h:mm t} ',
      dragOpacity: "0.5",
      eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
        return updateEvent(event);
      },
      eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
        return updateEvent(event);
      }
    });
  })
});

updateEvent = function(event) {
  return $.update(Routes.events_path(event.id), {
    event: {
      title: event.title,
      starts_at: "" + event.start,
      ends_at: "" + event.end,
      description: event.description
    }
  });
};

refactorJSON = function(json) {
  for(var i = 0; i < json.length; i++) {
    var obj = json[i];
    obj.title = obj.name;
    obj.start = new Date(obj.start_time);
    obj.end = new Date(obj.end_time);
    obj.allDay = false;

    delete obj.name;
    delete obj.start_time;
    delete obj.end_time;
  }
  return json;
};