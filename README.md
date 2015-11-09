# Space Performance [![Circle CI](https://circleci.com/gh/meteor-space/performance.svg?style=svg)](https://circleci.com/gh/meteor-space/performance)

Suite of tools to measure the performance of your Space system, in development or a staging production environment, with persistent reports.

## Tools
### Load Test(WIP)
Put your system under load by passing in a function and run spec, such as sending a command every 10 ms for 2 mins.


### Benchmark(Todo)
See how your infrastructure is performing using a standard test designed for maximum stress.

### Resiliance (Todo)
Put your distributed architecture to the test to ensure service outages are blips and not melt-downs.

## Install
`meteor add space:performance`  

## Optional Configuration
### Load Test
- `Configuration.performance.loadTest.defaultInterval`

### Reports
- `SPACE_PER_REPORTS_COLLECTION_NAME`
- `SPACE_PER_REPORTS_MONGO_URL`
- `SPACE_PER_REPORTS_MONGO_OPLOG_URL`

## Run the tests
1. `npm install -g mgp`
2. `mgp`
3. `./test.sh`

## Release History
You can find the release history in the [changelog](https://github.com/meteor-space/performance/blob/master/CHANGELOG.md)

## License
Licensed under the MIT license.
