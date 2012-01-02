module Helpers
  def section(name = nil)
  end

  def title(value = nil)
    @title = value if value
    @title ? @title : ""
  end

  def page_title
    @title ? "#{@title} ~ #{settings.website}" : settings.website
  end

  def container(value = nil)
    @container = value if value
    @container ? "cols-#{@container}" : "cols-sidenav"
  end
end
