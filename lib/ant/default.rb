#
# Задание списока bbcode-ов по-умолчанию
#
::Ant.config do

  tag :strong,  aliases: [
    :b,
    :bold,
    :жирный
  ]

  tag :em,      aliases: [
    :i,
    :курсив
  ]

  tag :u,       aliases: [
    :подчеркнуто
  ]

  tag :del,     aliases: [
    :s,
    :stroke,
    :перечеркнуто
  ]

  tag :blockquote, aliases: [
    :q,
    :quote,
    :цитата
  ]

  tag :p
  tag :ol
  tag :ul
  tag :li
  tag :dl
  tag :dt
  tag :dd
  tag :h1
  tag :h2
  tag :h3
  tag :h4
  tag :h5
  tag :h6

  tag :link, aliases: [
    :ссылка,
    :a
  ] do ->(args, options, content) {

      %Q(<a href='%{link}' rel="nofollow">%{content}</a>).freeze % {
        link:     args[0],
        content:  content
      }

    }

  end

end # config
