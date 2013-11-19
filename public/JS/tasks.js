function task (name, dueDate, priority, length)
{
	this.name = name;
	this.dueDate = dueDate;
	this.priority = priority;
	this.length = length;
}

var laundry = new task("Laundry", "11/26/13", 1, "60 min");
var homeWork = new task("Math Homework", "11/25/13", 2, "45 min");
var washCar = new task("Wash Car", "11/30/13", 3, "30 min");

var tasks = [homeWork,washCar,laundry];

function printToPage()
{
	document.write(
	<table>
		<tr>
			<td>tasks[0].name</td><td>tasks[0].dueDate</td><td>tasks[0].length</td>
		</tr>
		<tr>
			<td>tasks[1].name</td><td>tasks[1].dueDate</td><td>tasks[1].length</td>
		</tr>
		<tr>
			<td>tasks[2].name</td><td>tasks[2].dueDate</td><td>tasks[2].length</td>
		</tr>
	</table>
	);
}

function Welcome()
{
	alert("HELLO");
}