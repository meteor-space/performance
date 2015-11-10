Space.messaging.define(Space.messaging.Event, 'Space.performance', {

  LoadTestRunComplete: {
    name: String,
    runSpec: Match.Optional(Space.performance.LoadTestRunSpec),
    iterations: Number,
    startDate: Date,
    endDate: Date,
    duration: Number,
  }

});
