TUDU.tasks = {
	tasksJSON: [],

	init: function () {

	},

	create: function () {
		$.post(Routes.schedule_tasks_path(3))
		.done(function (data) {
			debugger;
			console.log(data);
			TUDU.tasks.tasksJSON = UTIL.refactorJSON(data);
			$('#calendar').fullCalendar('addEventSource', TUDU.tasks.tasksJSON);
		})
		.fail(function (jqXHR, textStatus, errorThrown) {
			console.log(jqXHR);
			debugger;
		});
	}
};