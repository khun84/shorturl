# README

## Description

**Shorturl** is an Rails app that mimic the feature of some common shorturl service provider like [bitly](https://bitly.com).

This app provides the following features:

1. Given a long url, it will generate a shortened url. The url target html page title will be captured with there is any. Note that update and delete feature are not available yet.
2. Redirect shortened url to the corresponding long url.
3. Provide simple reporting containing the following info:
   4. Total click count of each short url
   5. Each click event detail info including time, client ip and ip location

## Demo

The demo app is hosted in heroku => [https://warm-forest-21667.herokuapp.com/register](https://warm-forest-21667.herokuapp.com/reports/short_urls)

##  Tech stack

1. Rails 5.2
2. Ruby 2.7.3
3. Postgres (> 10)
4. Redis 5

## Initialise app

After pulling the repo, just do the following to start the app. The app will be served on `http://localhost:3000`. The port number is configurable by `rails s -p 1234`

```bash
rails db:create
rails db:migrate
rails s
```

## Technial Design

### ERD

<details>
    <summary>UML</summary>

```puml
class User

class Url {
    ==foreign keys==
    + user_id
    ==attributes==
    + title (String)
    + original_url (String)
}

class ShortUrl {
    ==foreign keys==
    + url_id
    ==attributes==
    + url_hash (String)
}

class UrlClick {
    ==foreign keys==
    + short_url_id
    + original_url_id
    ==attributes==
    + url_hash (String)
    + location_details (jsonb)
}

User -d-> Url : has many
Url -> ShortUrl : has many

ShortUrl -> UrlClick : generates click event
```

</details>

![erd-uml](http://www.plantuml.com/plantuml/png/bP1D3e8m48NtFSKiCOOBaDIDHo2kIIaZZDGsQGSJOhoxvKV4n63igdrlPhxNqKQ50AU0NWWztRs1ku1uf3mxZrHRQB4FKexY7hfON50rboXcJsN7-2vWOeEGvD6mzMuMdQUQh3955-SltkD5pHld-JVQcqtou3SgD5y0SVRHa6wt0M68KQmmdy7_X4-wSLenELjKo8fCWEGId2t7RCFY8QtImxZs368_N9NjnV2CwhAMbIKMSMgRlfL1ZHQzYeb0ZmhUqB9u0W00)

### Model Entity

#### Url

This is the long url that end user would like to convert to an short url.

#### ShortUrl

This is the short url that is generated for each given long url. Currently its generated using a simple random alphanumeric hash (permutation) which doesn't rely on the content of the long url.

#### UrlClick

This is a denormalized read model that is used to track the click event of each short url. There is no association being defined in the appliction layer as these event records can be moved to a different data storage that is optimised for its access pattern.

The click event origin location details is dumped inside a jsonb column. We can later provision additional columns for meaningful location detail such as `country` and `state` should the occasion arise (backfilling will be required but shouldn't be complicated).

### DB index suggestion

No indices were created in the db as the DDL was fairly straight forward. However, the consideration will be described here.

#### Url

Btree index on `user_id` should be sufficient.

#### ShortUrl

Btree index on `user_id`

The index type selection for `url_hash` worth some discussion here. One might tempted (so do I) to use **Hash** index for the benefit of a smaller index size and the O(1) complexity on read. However, this mean we need to live with the following limitation (subject to Postgres):

1. No quick range selection (though I have no idea when we will need this kind of access pattern)
2. No unique constraint checking in db runtime. Well, we can always do a uniqueness check in application runtime before writing to the db, but the time gap between uniqueness check and write commit has to be short. One might argue its url hash function is so good that he doesn't need this. Anyway, when more business rules being baked in (ie check plan quota and etc), the gap might be stretched to an extent that would invalidate our concurrency assumption.
3. Cannot be part of a combined index. Multiple index might be required if one would like to query short urls that belong to a particular long url.

#### UrlClick

This is a less frequently access (READ) table as compared to the aforementioned tables. However, each read might impose heavy load on the table due to its reporting nature.

A combined btree index on `created_at` and `url_hash` would be useful here.

In my opinion, we could just leave this table schema open ended and optimise it further when the occasion arise. We can explore the following options:

2. Provision dedicated read replica for OLAP-ish query.
3. More aggressive denormalisation to prevent joining. If we don't mind high data redundancy, we can dump all the required info in this table and move it to a different data storage engine that we see fit.
4. Introduce materialized view (roll up to hour should be sufficient for typical reporting) and refresh it periodically. Data stiching between the materialized view and live table might be required and its not friendly to pagination.
5. Introduce a cache layer on top of rdb. Note that the cache strategy for a paginable time dependent collection statistic view is kinda tricky hence this optimisation is listed as the last option.

### Click event processing

Currently the click event is being persisted in the db on real time basis. The db write is fairly straight forward hence the major bottleneck would most likely be the real time ip location lookup as its making an outbound http api call.

We can move this entire operation to a background queue when its time. Or we can compensate the ip lookup via background queue, but I would think this is too far-fetched.

### Short url life cycle management

Currently this is not given decent consideration in the app. However, I think its worth to discuss it here. **bitly** allows user to edit short url but the old short url would still be redirected to the previous long url (this was true within 5 minutes after a Free plan shorturl was changed, longer period x paid plan scenarios are not tested).

If we are to draw a quick conclusion from this observation, it seems like a short url will always point to the same long url once its published.