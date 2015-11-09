
{
  LoadTest, LoadTestComplete, LoadTestRunSpec
} = Space.performance

describe 'Space.performance.LoadTest', ->

  class MyCommand extends Space.messaging.Command
    @type 'Space.performance.__tests__.CommandStub'
    @fields: { first: String, second: Date }

  beforeEach ->
    @runFunction = -> Space.messaging.CommandBus.send(new MyCommand {  targetId: '123', first: 'value', second: new Date })
    @loadTest = new LoadTest('Server-side Command', @runFunction)
    @loadTest.meteor = Meteor
    @loadTest.eventBus = new Space.messaging.EventBus()

  describe 'construction', ->

    it 'has correct state when constructed', ->
      expect(@loadTest.name).to.equal 'Server-side Command'
      expect(@loadTest._runFunction).to.equal @runFunction
      expect(@loadTest._state).to.equal 'ready'

  describe 'running', ->

    afterEach ->
      @loadTest.finish()

    it "updates it's state when running", ->
      @loadTest.run(new LoadTestRunSpec({interval: 2, duration: 10}))
      expect(@loadTest._state).to.equal('running')

    it "sends commands at the optional defined interval when running", (test, waitFor) ->
      @loadTest.run(new LoadTestRunSpec({interval: 2, duration: 15}))
      timeout = =>
        try
          expect(@loadTest._iterations).to.be.within(4,6)
        catch err
          test.exception err
      Meteor.setTimeout(waitFor(timeout), 12);

    it "runs for the optional specified duration", (test, waitFor) ->
      @loadTest.run(new LoadTestRunSpec({interval: 2, duration: 10}))
      timeout = =>
        try
          expect(@loadTest._actualDuration).to.be.within(8,12)
        catch err
          test.exception err
      Meteor.setTimeout(waitFor(timeout), 10);

    it "protects against stopping the worker during a running test", ->
      @loadTest.run(new LoadTestRunSpec({interval: 2, duration: 10}))
      @loadTest._stopWorker()
      expect(@loadTest._state).to.equal 'running'

    it "throws error if missing run spec", ->
      expect(@loadTest.run).to.throw.error

    it "throws error unless spec object is of type Space.performance.LoadTestRunSpec", ->
      runWithoutValidSpec = -> @loadTest.run({interval: 2, duration: 10})
      expect(runWithoutValidSpec).to.throw.error

  describe 'finishing', ->

    it "publishes a run completed event when finished", ->
      subscriber = sinon.spy()
      @loadTest.eventBus.subscribeTo LoadTestComplete, subscriber
      @loadTest.run(new LoadTestRunSpec({interval: 2, duration: 10}))
      @loadTest.finish()
      expect(subscriber).to.have.been.calledWithMatch sinon.match.instanceOf LoadTestComplete
