require "rouge/plugins/redcarpet"

module RougePlugin
  include Rouge::Plugins::Redcarpet
  def rouge_formatter(lexer)
    formatter = ::Rouge::Formatters::HTMLLegacy.new(css_class: "text-sm #{lexer.tag}")
    @highlights ||= ""
    highlight_lines = @highlights.split(",").map do |h|
      m = h.match(/\A(\d+)(\.\.|-)(\d+)\z/)
      if m.present?
        Range.new(m[1].to_i, m[3].to_i)
      elsif h.match?(/\A[-+]\d+\z/)
        h
      else
        h.to_i
      end
    end
    formatter = ::Rouge::Formatters::HTMLLineHighlighter.new(formatter, highlight_lines: highlight_lines)
    formatter
  end
end

module Rouge
  module Formatters
    class HTMLLineHighlighter < Formatter
      def stream(tokens)
        token_lines(tokens).with_index(1) do |line_tokens, lineno|
          line = %(#{@delegate.format(line_tokens)}\n)
          highlight = @highlight_lines.any? { |l| l === lineno } # === for Range#cover?
          diff_class = if @highlight_lines.include?("+#{lineno}")
            "hll-add"
          elsif @highlight_lines.include?("-#{lineno}")
            "hll-rem"
          end
          line = %(<div class="#{@highlight_line_class} #{diff_class}">#{line}</div>) if highlight || diff_class
          yield line
        end
      end
    end
  end
end

class TailwindHtmlRenderer < Redcarpet::Render::HTML
  include ActionView::Helpers::SanitizeHelper
  include RougePlugin

  def table(header, body)
    <<~HTML.chomp
      <table class="w-full">#{header}#{body}</table>
    HTML
  end

  def link(link, title, content)
    link = sanitize(link)

    <<~HTML.chomp
      <a
        #{"data-controller=\"anchor\" data-action=\"anchor#follow\"" if link.match?(/\A#.+/)}
        href="#{link}"
        class="decoration-inherit underline"
      >#{content}</a>
    HTML
  end

  def paragraph(text)
    <<~HTML.chomp
      <p class="mb-4">#{text}</p>
    HTML
  end

  def codespan(code)
    <<~HTML.chomp
      <span class="inline-code border font-mono py-[0.13rem] px-2">#{code}</span>
    HTML
  end

  def block_code(code, lang)
    m = lang&.match(/\A([a-z-]+)#?(.+)?\z/)
    language = m.present? ? m[1] : nil
    @highlights = m.present? ? m[2] : ""
    <<~HTML.chomp
      <div class="code-outer">
        <div class="code">
          #{super(code, language)}
        </div>
      </div>
    HTML
  end

  def block_quote(quote)
    <<~HTML.chomp
      <blockquote class="mb-8 border-l-[0.2rem] border-gray-500 dark:border-gray-400 pl-4 ml-2 text-gray-500 dark:text-gray-400">#{quote}</blockquote>
    HTML
  end

  def list(contents, list_type)
    tag = case list_type.to_s
    when :ordered
      "ol"
    else
      "ul"
    end

    <<~HTML.chomp
      <#{tag} class="pl-4 my-6">#{contents}</#{tag}>
    HTML
  end

  def list_item(text, list_type)
    list_class = case list_type
    when :ordered
      "list-decimal"
    else
      "list-disc"
    end

    <<~HTML.chomp
      <li class="ml-6 leading-1 #{list_class}">#{text}</li>
    HTML
  end

  def header(text, level)
    text_size = %w[
      text-6xl
      text-4xl
      text-2xl
      text-xl
      text-lg
      text-md
    ][level - 1]
    weight = if level < 3
      "font-bold"
    elsif level < 5
      "font-semibold"
    else
      "font-medium"
    end
    margins = case level
    when 1
      "mt-20 mb-3"
    when 2
      "mt-12 mb-1"
    when 3
      "mt-6"
    else
      "mt-3"
    end
    <<~HTML.chomp
      <h#{level} id="#{text.parameterize}" class="#{margins} #{text_size} #{weight} first:mt-0">#{text}</h#{level}>
    HTML
  end
end
