# Logging and monitoring chat
Have a look at the relevant sections from [leanstack](http://leanstack.io/categories)

## Logging
Logging:
* What is it?
* How do you do it per machine?
* How do you do it across a datacentre?
* How do you get utility from it?

Have a look at:

* [Rsyslog](https://en.wikipedia.org/wiki/Rsyslog), [syslog-ng](https://en.wikipedia.org/wiki/Syslog-ng) can do log aggregation
* [Logstash](http://logstash.net/) aggregates logs and provides a query interface
* [Splunk](http://www.splunk.com/) is a commercial alternative

## Monitoring
* What is it
* How does it tie with logging.
* What does it give you?
* How do you get alerts?

Have a look at:

* [New Relic](http://leanstack.io/new-relic) for code instrumentation
* [Graphite](http://graphite.readthedocs.org/en/latest/overview.html) can do [metrics display](http://jondot.github.io/graphene/) and [metric math](https://graphite.readthedocs.org/en/1.0/functions.html). It also has a [hosted mode](https://www.hostedgraphite.com/) for metrics
* [Pagerduty](http://leanstack.io/pagerduty) for alerting and [escalation](http://www.pagerduty.com/tour/easy-setup/). Supports [oncall scheduling](http://www.pagerduty.com/tour/on-call-scheduling/)
* [Piwik](http://demo.piwik.org/index.php?module=CoreHome&action=index&idSite=7&period=day&date=yesterday#/module=Dashboard&action=embeddedIndex&idSite=7&period=day&date=yesterday&idDashboard=1) has a dashboard for webdevs.


## Deployments 
* Use [configuration management]. For example [Juniper supports chef](http://www.juniper.net/techpubs/en_US/junos-chef11.10/topics/concept/chef-for-junos-overview.html)
* Automate deployments as much as possible. For example, use a [Continuous integration pipeline ](https://en.wikipedia.org/wiki/Continuous_integration)
* Have automatic alarms and sensible metrics to track your deployment.
* Use Configuration management to manage your deployments. 
