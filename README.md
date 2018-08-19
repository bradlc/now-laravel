# now-laravel

> Run [Laravel](https://laravel.com/) on [Now](https://zeit.co/now)

Based on [now-examples/php-7-hello-world](https://github.com/zeit/now-examples/tree/master/php-7-hello-world) and [Creating Multi-Stage Docker Builds for Laravel](https://laravel-news.com/multi-stage-docker-builds-for-laravel)

```
git clone https://github.com/bradlc/now-laravel.git
```

```
cd now-laravel
```

```
cp .env.example .env && php artisan key:generate
```

```
npm run deploy
```

To use an env file other than `.env`:

```
DOT_ENV=.env.production npm run deploy
```
