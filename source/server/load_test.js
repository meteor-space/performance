
Space.Object.extend(Space.performance, 'LoadTest', {

  ERRORS: {
    nameRequired: function() {
      return 'Load Tests need a name on creation.';
    },
    runFunctionRequired: function() {
      return 'Load Tests need a run function on creation.';
    },
    runSpecRequired: function() {
      return 'Need a run spec when running.';
    }
  },

  Dependencies: {
    meteor: 'Meteor'
  },

  name: null,
  _state: null,
  _runFunction: null,
  _runSpec: null,
  _worker: null,
  _iterations: null,
  _startDate: null,
  _endDate: null,
  _actualDuration: null,

  Constructor: function(name, runFunction) {
    if(!name) throw new Error(this.ERRORS.nameRequired());
    if(!runFunction) throw new Error(this.ERRORS.runFunctionRequired());
    this.name = name;
    this._runFunction = runFunction;
    this._state = 'ready';
  },

  run: function(spec) {
    if(this._state != 'ready') return;
    if(!spec) throw new Error(this.ERRORS.runSpecRequired());
    this._runSpec = spec;
    this._state = 'running';
    this._iterations = 0;
    this._startDate = new Date();
    this._setTimeout();
    var self = this;
    this._worker = this.meteor.setInterval(function(){
      self._iterations++;
      return self._runFunction
    }, this._runSpec.interval)
  },

  finish: function() {
    if(this._state !== 'running') return;
    this._state = 'finishing';
    this._stopWorker();
    this._endDate = new Date();
    this._actualDuration = this._endDate - this._startDate;
    var completedEvent = new Space.performance.LoadTestComplete({
      name: this.name,
      runSpec: this._runSpec,
      iterations: this._iterations,
      startDate: this._startDate,
      endDate: this._endDate,
      actualDuration: this._actualDuration
    });
    this.publish(completedEvent);
    return this._state = 'ready';
  },


  _setTimeout: function() {
    var self = this;
    return this.meteor.setTimeout((function() {
      return self.finish();
    }), this._runSpec.duration);
  },

  _stopWorker: function() {
    if(this._state !== 'finishing') return;
    return this.meteor.clearInterval(this._worker);
  }

});

Space.performance.LoadTest.mixin(Space.messaging.EventPublishing);
