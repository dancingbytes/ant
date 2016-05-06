#
# Вспомогательные модули
#
module Ant

  module Cleaner

    extend self

    def all(html)
      wls.sanitize(html, tags: [])
    end # all

    def twitter(html)
      wls.sanitize(html, tags: %w(p a), attributes: %w(href))
    end # twitter

    def instagram(html)
      wls.sanitize(html, tags: %w(p a), attributes: %w(href))
    end # instagram

    private

    def wls
      @wls ||= ::Rails::Html::WhiteListSanitizer.new
    end # wls

  end # Cleaner

  module Snippet

    extend self

    TWEETER_URL   = %Q(https://api.twitter.com/1/statuses/oembed.json?url=%{val}).freeze
    TWEETER_CODE  = %Q(<blockquote class="twitter-tweet tw-align-center">%{html}</blockquote>).freeze

    INSTA_URL     = %Q(https://api.instagram.com/oembed/?url=%{val}).freeze
    INSTA_CODE    = %Q(
      <blockquote class="instagram-media"
        data-instgrm-captioned=""
        data-instgrm-version="6">%{html}</blockquote>
    ).freeze

    YOUTUBE_CODE  = %Q(
      <div class="video-wrapper">
        <iframe class="youtube-video" width="%{width}" height="%{height}"
        src="https://www.youtube.com/embed/%{val}"
        frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
      </div>
    ).freeze

    COUB_CODE     = %Q(
      <div class="video-wrapper">
        <iframe class="coub-video"
        src="//coub.com/embed/%{val}?muted=false&autostart=false&originalSize=false&hideTopBar=true&startWithHD=false"
        webkitallowfullscreen mozallowfullscreen allowfullscreen
        allowfullscreen="true" frameborder="0"
        width="%{width}" height="%{height}"></iframe>
      </div>
    ).freeze

    SCRIPT_CODE   = %Q(
      <div class="script-wrapper">
        <script src="%{val}"></script>
      </div>
    ).freeze

    VIMEO_CODE    = %Q(
      <div class="video-wrapper">
        <iframe class="vimeo-video" width="%{width}" height="%{height}"
        src="https://player.vimeo.com/video/%{val}?color=ffffff&title=0&byline=0&portrait=0&badge=0"
        frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
      </div>
    ).freeze


    def tweet(args, options, content)

      url = TWEETER_URL % {
        val: args[0]
      }

      html = get_resource(url)["html"]
      return "" if html.blank?

      TWEETER_CODE % {
        html: ::Ant::Cleaner.twitter(html)
      }

    end # tweet

    def instagram(args, options, content)

      url = INSTA_URL % {
        val: args[0]
      }

      html = get_resource(url)["html"]
      return "" if html.blank?

      INSTA_CODE % {
        html: ::Ant::Cleaner.instagram(html)
      }

    end # instagram

    def youtube(args, options, content)

      url = (args[0] || "")
      url = url.scan(/\?v=(\S+)/).flatten.first || url.scan(/youtu.be\/(\S+)/).flatten.first

      return "" if url.blank?

      YOUTUBE_CODE % {
        val:    url,
        width:  '750',
        height: '100%'
      }

    end # youtube

    def coub(args, options, content)

      url = (args[0] || "")
      url = url.scan(/coub.com\/view\/(\S+)/).flatten.first || url.scan(/coub.com\/embed\/(\S+)/).flatten.first

      return "" if url.blank?

      COUB_CODE % {
          val:    url,
          width:  '750',
          height: '100%'
        }

    end # coub

    def script(args, options, content)

      url = (args[0] || "")

      return "" if url.blank?

      SCRIPT_CODE % {
        val: url
      }

    end # script

    def vimeo(args, options, content)

      url = (args[0] || "")
      url = url.scan(/vimeo.com\/(\S+)/).flatten.first

      return "" if url.blank?

      VIMEO_CODE % {
        val:    url,
        width:  '750',
        height: '100%'
      }

    end # vimeo

    private

    def get_resource(url, limit = 3)

      res = ::Net::HTTP.get_response(URI(url))

      return {} if limit < 0

      case res
        when Net::HTTPSuccess then
          ::JSON.parse(res.body) rescue {}
        when Net::HTTPRedirection then
          get_resource(res['location'], limit - 1)
        else
          {}
      end

      rescue => e
        {}

    end # get_resource

  end # Snippet

end # Ant

#
# Дополнительные BBCode-а и их обработчики
#
::Ant.config do

  # Instagram
  tag :instagram, singular: true, aliases: [
    :insta,
    :instagramm,
    :инстаграм,
    :инстаграмм
  ] do |args, options, content|
    ::Ant::Snippet.instagram(args, options, content)
  end

  # Twitter
  tag :tweet , singular: true, aliases: [
    :twit,
    :twet,
    :tweeter,
    :twitter,
    :twiter,
    :твит,
    :твитер,
    :твиттер
  ] do |args, options, content|
    ::Ant::Snippet.tweet(args, options, content)
  end

  tag :youtube, singular: true, aliases: [
    :ютюб,
    :utube
  ] do |args, options, content|
    ::Ant::Snippet.youtube(args, options, content)
  end

  tag :coub, singular: true, aliases: [
    :коуб
  ] do |args, options, content|
    ::Ant::Snippet.coub(args, options, content)
  end

  tag :script, singular: true, aliases: [
    :js,
    :скрипт
  ] do |args, options, content|
    ::Ant::Snippet.script(args, options, content)
  end

  tag :vimeo, singular: true, aliases: [
    :вимео
  ] do |args, options, content|
    ::Ant::Snippet.vimeo(args, options, content)
  end

end
