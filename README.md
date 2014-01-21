# Minerva

Minerva is a simple server side app that serves as a content aggregator. You can run your own Minerva aggregator and quickly customize content sources. 

Minerva uses PubSubHubBub (PSHB) protocol to recieve new feed entries is real time, learn more [here](https://code.google.com/p/pubsubhubbub/). You should create an account at [superfeedr.com](http://superfeedr.com/) to allow receiving of PSHB notification from feeds that do not explicitly push to a PSHB hub.

### Dependencies

#### Ruby Gems
- whenever - for scheduling recuring taks, updating social metrics periodically in this case
- delayed_job - for running background jobs to query social api's (fb, twitter)
- feedzira - for parsing feed's

#### External
Superfeedr - to allow subscription to feeds that do not conform to PSHB protocol

### Database
Minerva uses postgreSQL as its DBMS to enable complex queries of its social metrics tables. Minerva has the following database tables:

- hubs
- sites
- feeds
+ posts
+ social_metrics
+ latest_social_metrics

The only table than you currently need to manually manage and add entries to is feeds.

#### Adding a new content sources
Creating a new entry in the feeds table will add that feed to the list of sources from which to gather content for aggregation. A feed entry should be the address of an RSS or atom feed.

## Setup/Customization
Once you have created a superfeedr account you will need to change the following 3 lines of code in pub_sub_controller.rb to be your own username/password

@superfeedr_username = "username"
@superfeedr_password = "password"
@pub_sub_callback = "/pub_sub/callback"

The first two are self explanatory, @pub_sub_callback is the callback that the PSHB hub will send notifications to. This path is relative to your root route, make sure the route is accessible.

## Adding a new content sources
Creating a new entry in the feeds table will add that feed to the list of sources from which to gather content for aggregation. A feed entry should be the address of an RSS or atom feed.


<tt>rake doc:app</tt>.
