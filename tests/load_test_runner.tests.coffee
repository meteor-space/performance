
{
  LoadTestRunner, LoadTestRunComplete, LoadTestRunSpec
} = Space.performance

describe 'Space.performance.LoadTestRunner', ->

  class MyCommand extends Space.messaging.Command
    @type 'Space.performance.__tests__.CommandStub'
    @fields: { first: String, second: Date }

  beforeEach ->
    @runFunction = -> Space.messaging.CommandBus.send(new MyCommand {  targetId: '123', first: 'value', second: new Date })
    @testRun = new LoadTestRunner('Server-side Command', @runFunction)
    @testRun.meteor = Meteor
    @testRun.eventBus = new Space.messaging.EventBus()

  describe 'construction', ->

    it 'has correct state when constructed', ->
      expect(@testRun.name).to.equal 'Server-side Command'
      expect(@testRun._runFunction).to.equal @runFunction
      expect(@testRun._state).to.equal 'ready'

  describe 'starting', ->

    afterEach ->
      @testRun.finish()

    it "throws error if missing run spec", ->
      expect(@testRun.start).to.throw.error

    it "throws error unless spec object is of type Space.performance.LoadTestRunSpec", ->
      runWithoutValidSpec = -> @testRun.start({interval: 2, duration: 10})
      expect(runWithoutValidSpec).to.throw.error

    it "updates it's state after starting", ->
      @testRun.start(new LoadTestRunSpec({interval: 2, duration: 10}))
      expect(@testRun._state).to.equal('running')

  describe 'running', ->

    afterEach ->
      @testRun.finish()

    it "runs the provided function at approximately the defined interval", (test, waitFor) ->
      @testRun.start(new LoadTestRunSpec({interval: 4, duration: 20}))
      timeout = =>
        try
          expect(@testRun._iterations).to.be.within(2,5)
        catch err
          test.exception err
      Meteor.setTimeout(waitFor(timeout), 17);

    it "runs for the approximately the specified duration", (test, waitFor) ->
      @testRun.start(new LoadTestRunSpec({interval: 4, duration: 10}))
      timeout = =>
        try
          expect(@testRun._duration).to.be.within(9,20)
        catch err
          test.exception err
      Meteor.setTimeout(waitFor(timeout), 10);

    it "protects against stopping the worker during a running test", ->
      @testRun.start(new LoadTestRunSpec({interval: 2, duration: 10}))
      @testRun._stopWorker()
      expect(@testRun._state).to.equal 'running'


  describe 'finishing', ->

    it "publishes a run completed event when finished", ->
      subscriber = sinon.spy()
      @testRun.eventBus.subscribeTo LoadTestRunComplete, subscriber
      @testRun.start(new LoadTestRunSpec({interval: 2, duration: 10}))
      @testRun.finish()
      expect(subscriber).to.have.been.calledWithMatch sinon.match.instanceOf LoadTestRunComplete
