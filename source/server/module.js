
Space.performance = Space.Module.define('Space.performance', {

  RequiredModules: ['Space.messaging'],

  onInitialize: function () {
    this.injector.map('Space.performance.LoadTestRunner').asStaticValue();
  }

});
