%{
  title: "Understanding PostgreSQL and its buffers",
  description: "PostgreSQL's buffer cache plays a crucial role in maintaining high performance. In this article, I conduct some experiments and show how the buffer cache affects performance.",
  keywords: ["postgres", "database"],
  draft: true,
}

---


[PostgreSQL](https://www.postgresql.org/) is an open source relational database engine. It has been around for some 35 years, is highly performant, scalable horizontally through replication and is widely used. Major cloud providers offer managed solutions for Postgres, with additions such as automatic failover and recover, and automatic maintenance.

## What is the Buffer Cache?

The buffer cache is, simply put, a caching mechanism to speed up reading of data. Since Postgres stores data on disk, any I/O reads to the storage layer will incur extra delay. The cache on the other hand lives in memory, providing much lower delay. The performance difference is an order of magnitude, something we'll see later in this post.

There is more than one cache in Postgres, but in this post I'll only focus on `shared_buffers`, which is the main cache for reading data.

### Structure of shared_buffers

The smallest unit in Postgres is a `page`, defaulting to 8kB. A row of data in a table will be stored in at least one page - if the size of the row exceeds the page size, it will be distributed among multiple pages. Simple stuff.

The `shared_buffers` will only cache pages. The implication of this is that rows that hasn't been read might be cached, since neighbouring (page-wise) rows have been read.

## Experimenting with the Cache

Let's start by enabling an extension which will allow us to read the contents of the cache:

```sql
create extension pg_buffercache;

select * from table;
```