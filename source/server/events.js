Space.messaging.define(Space.messaging.Event, 'Space.performance', {

  LoadTestComplete: {
    name: String,
    runSpec: Match.Optional(Space.performance.LoadTestRunSpec),
    iterations: Number,
    startDate: Date,
    endDate: Date,
    actualDuration: Number,
  }

});
