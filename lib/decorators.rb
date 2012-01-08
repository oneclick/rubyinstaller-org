module Decorators
  class Release
    DOWNLOAD_URL = "/downloads/%s/%s".freeze

    def initialize(release)
      @release = release
    end

    def title
      "#{@release.package} #{@release.version}"
    end

    def date
      @release.date.strftime "%Y-%m-%d"
    end

    def links
      links = []

      @release.files.each do |file|
        url = file_url(file)
        text, css = file_text_class(file)

        links << Link.new(url, text, "tag #{css}")
      end

      links << Link.new("", "Show notes", "tag trigger")

      links
    end

    def notes
      html = ["<strong>MD5:</strong>"]

      @release.files.each do |file|
        html << "#{file.md5} *#{file.filename}"
      end

      unless @release.notes.empty?
        html << "<hr />"
        html << "<strong>Notes:</strong>"
        html << @release.notes
      end

      html.join("\n")
    end

  private

    def file_text_class(file)
      case
      when file.installer?
        ["Installer", "tag-installer"]
      when file.binary?
        ["7-zip", "tag-sevenzip"]
      when file.documentation?
        ["Documentation", "tag-doc"]
      when file.devkit?
        ["SFX", "tag-devkit"]
      end
    end

    def file_url(file)
      # DevKit do not use version as directory separator
      base = if file.devkit? && @release.package == ::Release::DEVKIT
        "devkits"
      else
        @release.version
      end

      DOWNLOAD_URL % [base, file.filename]
    end
  end

  class Link
    attr_reader :href, :text, :css

    # Public: Create a Decorator link using href and text with optional
    # css styling.
    #
    # href - The String where this Link will point to.
    # text - The String which will display this link.
    # css  - The String with CSS classes for this link (optional).
    #
    # Returns a Link instance.
    def initialize(href, text, css = nil)
      @href = href
      @text = text
      @css  = css
    end

    # Public: Represent the Link using HTML 'a' tag and will include CSS class
    # definition if present.
    #
    # Returns a String with the HTML element described.
    def to_html
      html = "<a href=#{@href.chomp.inspect}"
      html << " class=#{@css.chomp.inspect}" if @css
      html << ">#{@text}</a>"

      html
    end
  end
end
