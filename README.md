# FlyExample
> A project from [DailyDrip](https://www.dailydrip.com).

This is an example application showing off usage of my
[fly](http://github.com/dailydrip/fly) on-the-fly file processing framework for
Elixir.  If you load it up and visit the root, you'll see an image that's
resized on the fly.

## Too lazy to pull it down?

[Here's a demo, running on Heroku.](https://immense-forest-64118.herokuapp.com/)

## Deploying it yourself

Just push to heroku, using the following buildpacks:

```
https://github.com/HashNuke/heroku-buildpack-elixir.git
https://github.com/gjaldon/heroku-buildpack-phoenix-static.git
https://github.com/amberbit/heroku-buildpack-goon.git
https://github.com/ello/heroku-buildpack-imagemagick
https://github.com/jonathanong/heroku-buildpack-ffmpeg-latest.git
https://github.com/debitoor/heroku-buildpack-converter-fonts.git
```

## About [DailyDrip](https://www.dailydrip.com)

[![DailyDrip](https://github.com/dailydrip/fly/raw/master/assets/dailydrip.png)](https://www.dailydrip.com)

> This code is part of [Elixir Drips](https://www.dailydrip.com/topics/elixir/),
> a daily continous learning website where you can just spend 5 minutes a day to
> learn more about Elixir (or other things!)

