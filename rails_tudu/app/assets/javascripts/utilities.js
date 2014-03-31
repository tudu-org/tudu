UTIL = {
  
    /* @function: init
     * Initial function to be invoked for UTIL
     *
     * @param: NONE
     * 
     * Executes site-wide javascript (common)
     * Then finds all elements with data-controller and data-action attributes
     * For each element, execute controller-action pair
     */
    init: function () {
        UTIL.exec("common");

        // Returns all elements with data-controller/data-action attributes
        $.each(document.querySelectorAll("[data-controller][data-action]") ,function (i, element) {
            var controller = element.getAttribute("data-controller");
            var action = element.getAttribute("data-action");
            
            UTIL.exec(controller);

            if(action !== "") {
                // ATTN: Hack so that index action is not executed twice
                if(!((controller === "calendar" || controller === "home") && action === "index")) { 
                    UTIL.exec(controller, action);
                }
            }
        });
    },

    /* @function: exec
     * Executes a controller action based on data-controller and data-action attributes in markup

     * @param: controller - [REQUIRED] Controller that hosts @param[action]
     * @param: action - [Optional] Action to be executed
     *
     * IF @param[action] is null THEN call "init" action in @param[controller]
     * ELSE call @param[action] in @param[controller]
     */
    exec: function (controller, action) {
        var namespace = TUDU;
        var action = (action === undefined) ? "init" : action; // If no action is passed in, call "init()"

        // If the controller exists and action is a function
        if (controller !== "" && namespace[controller] && typeof namespace[controller][action] == "function") {
            namespace[controller][action](); // Execute action
        }
    },

    modifyJSON: function (json, callback) {
        if (json instanceof Array) {
           for(i in json) {
                callback(json[i]);
           } 
        } else {
            callback(json);
        }
        return json;
    },

    /* @function: refactorJSON
     * Refactors response JSON from GET events/tasks for 
     * the FullCalendar Plugin
     *
     * @param: json - Response JSON from GET request
     * @return: json - Refactored JSON
     *
     * Renames/reformats some key-value pairs for each JSON object
     */
    refactorJSON: function (json) {
        // console.log(json);
        return this.modifyJSON (json, refactorObj);

        function refactorObj ( obj ) {
            obj.title = obj.name;
            obj.start = new Date(obj.start_time);
            obj.end = new Date(obj.end_time);
            obj.allDay = false; // Does not exist in model yet
        };
    },

    unrefactorJSON: function (json) {
        return this.modifyJSON (json, unrefactorObj);
        
        function unrefactorObj ( obj ) {
            delete obj.title;
            delete obj.start;
            delete obj.end;
            delete obj.allDay;

            // Injected JSON by FullCalendar
            delete obj._end;
            delete obj._id;
            delete obj._start;
            delete obj.className;
            delete obj.source;
        };
    }
};

$(document).ready(UTIL.init);