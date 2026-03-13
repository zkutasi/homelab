# Uptime monitoring

These apps provide application level monitoring, usually per app the UP/DOWN state is checked via HTTP/DNS/TCP checks, and a historical chart is presented. Dashboards can be made based on the monitors and a notification system is used to push alerts of DOWN states.

## Requirements

- Free and Open source, preferably 0$ cost
- Various checks possible: HTTP (result codes, response body, headers), ICMP, DNS, latency, etc...
- Possibility to configure via Code or API

## Contenders

- [Uptime Kuma](https://uptime.kuma.pet/) - An easy-to-use self-hosted monitoring tool
  - [AutoKuma](https://github.com/BigBoot/AutoKuma) - With AutoKuma, you can eliminate the need for manual monitor creation in the Uptime Kuma UI.
- [Statping NG](https://statping-ng.github.io/) - An updated drop-in for statping. A Status Page for monitoring your websites and applications with beautiful graphs, analytics, and plugins. Run on any type of environment.
- [Peekaping](https://peekaping.com/) - An uptime monitoring system built with Golang and React. You can monitor your websites, API and many more leveraging beautiful status pages, alert notifications.
- [CheckCle](https://checkcle.io/) - CheckCle is a self-hosted, open-source monitoring platform for seamless, real-time full-stack systems, applications, and infrastructure. It provides real-time uptime monitoring, distributed checks, incident tracking, and alerts. All deployable anywhere.
- [CheckMate](https://checkmate.so/) - An open-source, self-hosted tool designed to track and monitor server hardware, uptime, response times, and incidents in real-time with beautiful visualizations.
- [Gatus](https://gatus.io/) - Gatus is a developer-oriented health dashboard that gives you the ability to monitor your services using HTTP, ICMP, TCP, and even DNS queries as well as evaluate the result of said queries by using a list of conditions on values like the status code, the response time, the certificate expiration, the body and many others. The icing on top is that each of these health checks can be paired with alerting via Slack, Teams, PagerDuty, Discord, Twilio and many more.
- [Kuvasz](https://kuvasz-uptime.dev/) - An open-source uptime and SSL monitoring service, with multiple notification channels, status pages, IAC support via YAML, Prometheus integration, a complete REST API and many more!
- [Tianji](https://tianji.dev/) - Insight into everything, Website Analytics + Uptime Monitor + Server Status.
- [Vigil](https://github.com/valeriansaliou/vigil) - Microservices Status Page. Monitors a distributed infrastructure and sends alerts (Slack, SMS, etc.).
- [HealthChecks](https://healthchecks.io/) - Healthchecks.io listens for HTTP requests ("pings") from your cron jobs and scheduled tasks. It keeps silent as long as pings arrive on time. It raises an alert as soon as a ping does not arrive on time.
- [Cachet](https://cachethq.io/) - Cachet, the open-source self-hosted status page system. Abandoned since 2023.
- [Kener](https://kener.ing/) - Stunning status pages, batteries included!
