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

end # config
