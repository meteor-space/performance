Package.describe({
  summary: 'Suite of tools to test and measure the performance of your Space system',
  name: 'space:performance',
  version: '0.1.0',
  git: 'https://github.com/meteor-space/performance.git',
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'ejson',
    'underscore',
    'check',
    'mongo',
    'space:base@3.2.1',
    'space:messaging@2.1.0'
  ]);

  api.addFiles('source/client/module.js','client');
  api.addFiles('source/server/module.js','server');

  api.addFiles([
    'source/commands.js'
  ]);

  api.addFiles([
    'source/server/value_objects/load_test_run_spec.js',
    'source/server/load_test_runner.js',
    'source/server/events.js'
  ], 'server');


});

Package.onTest(function(api) {

  api.use([
    'coffeescript',
    'check',
    'ejson',
    'mongo',
    'underscore',
    'space:performance',
    'space:messaging@2.1.0',
    'space:testing@2.0.0',
    'practicalmeteor:munit@2.1.5',
  ]);

  api.addFiles([
    'tests/load_test_runner.tests.coffee',
  ], 'server');

});
