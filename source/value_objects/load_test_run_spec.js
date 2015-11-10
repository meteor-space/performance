Space.messaging.Serializable.extend(Space.performance, 'LoadTestRunSpec', {
  // EJSON serializable fields
  fields: function() {
    return {
      interval: Number,
      duration: Number
    };
  }
});

// Register as EJSON type
Space.performance.LoadTestRunSpec.type('Space.performance.LoadTestRunSpec');
