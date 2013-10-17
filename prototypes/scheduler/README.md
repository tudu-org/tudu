# is-algo-proto Tudu scheduling algorithm prototype

A utility intended to test the algorithm for our senior capstone project: Tudu.

## Usage

In order to build/compile this project you will need leiningen installed <http://leiningen.org/>. From there just use 'lein run' to just interpret it or 'lein uberjar' to build a complete java archive of it.

The utility takes in a json file called a dispatch. It should have a format like the one in resources/test_dispatch_one.json.  That is, you should describe the schedule and then list any tasks you want to complete.  You shoul dalso include a start and end time for the entire dispatch to frame itself around.

assuming 'is-algo.jar' is the name of your jar file, you can use it as follows

  java -jar is-algo.jar -i <input_dispatch.json> -o <output_scheduled.json>

This will generate a json file similar to the input one except with the tasks specified placed into the schedule.  If the tasks could not be placed in the schedule they will be in an array at the "failed" key.

In addition, you can output to an svg so you can visualize the way that tasks are scheduled like so:

  java -jar is-algo.jar -i <input_dispatch.json> -o <output_image.svg> -f svg

The resulting svg can be best viewed using a web browser of your choice.

Finally, can can get the raw priority values of the tasks to dump to a json file like so:

  java -jar is-algo.jar -i <input_dispatch.json> -o <output_dump.json> -p

## License

Copyright © 2013 Tudu Team

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.
