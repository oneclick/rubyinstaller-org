require "psych"
require "time"

class Release < Struct.new(:package, :version, :date, :files, :notes)
  FEATURED = ["1.9.3", "1.9.2", "1.8.7"].freeze

  private_class_method :new

  # Public: List of all releases loaded.
  #
  # Returns an Array of releases ordered by newest first or empty array.
  def self.all
    @@releases ||= []
  end

  # Public: Load release information from YAML files.
  #
  # data_dir - String that represents the directory where YAML files will be
  #            loaded from (default: data/releases).
  #
  # Examples
  #
  #   Release.reload! "./data/releases"
  #   # => true
  #
  #   Release.reload! "/tmp"
  #   # => false
  #
  # Returns true or false if releases were loaded.
  def self.reload!(data_dir = nil)
    data_dir ||= ::File.expand_path("../../data/releases", __FILE__)

    files = Dir.glob("#{data_dir}/**/*.yml")

    @@releases = files.collect { |f| from_file(f) }

    # sort by date of release (newest first)
    @@releases.sort_by! { |r| r.date }.reverse!

    !@@releases.empty?
  end

  # Internal: Build a Release loading content from a YAML file.
  #
  # filename - String that represents the path (absolute or relative) to the
  #            YAML document to be loaded.
  #
  # Examples
  #
  #   Release.from_file("path/to/release.yml")
  #   # => => #<struct Release package=...>
  #
  # Returns a Release that represent loaded contents.
  def self.from_file(filename)
    data = Psych.load ::File.read(filename)

    package = data.fetch("package")
    version = data.fetch("version")
    date    = Time.parse data.fetch("date").to_s
    notes   = data.fetch("notes", "")
    list    = data.fetch("files", [])

    files   = list.collect { |d| Release::File.from_hash(d) }

    new package, version, date, files, notes
  end
  private_class_method :from_file

  # Public: Retrieve the latest releases of 'ruby' package that were marked
  # in Release::FEATURED.
  #
  # Returns an Array of Release that matches the criteria or empty array.
  def self.featured_ruby
    selected = {}

    all.each do |release|
      # skip non-ruby packages
      next unless release.package == "ruby"

      # grab only the X.Y.Z part of the version
      version = release.version.split("-").first

      # is this one featured and not already selected?
      # (only one can be selected)
      if FEATURED.include?(version) && !selected.has_key?(version)
        selected[version] = release
      end
    end

    # now construct resulting array in the order described by FEATURED
    # (dropping possible nil results)
    FEATURED.collect { |version| selected[version] }.compact
  end

  class File < Struct.new(:filename, :size, :md5, :kind)
    private_class_method :new

    # Internal: Build a Release File using provided hash contents. Used by
    # Release::from_file when creating a Release instance.
    #
    # Returns a Release::File instance.
    def self.from_hash(data)
      filename = data.fetch("filename")
      size     = data.fetch("size")
      md5      = data.fetch("md5")
      kind     = data.fetch("kind").to_sym

      new filename, size, md5, kind
    end
  end
end
