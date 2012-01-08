require "psych"
require "time"

class Release
  FEATURED = ["1.9.3", "1.9.2", "1.8.7"].freeze
  RUBY     = "Ruby".freeze
  DEVKIT   = "DevKit".freeze

  attr_reader :package, :version, :date, :files, :notes

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
      next unless release.package == RUBY

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

  # Public: Retrieve the last 'devkit' package available.
  #
  # Returns a Release Array with one single element.
  def self.featured_devkit
    [all.find { |release| release.package == DEVKIT }]
  end

  # Internal: Build a Release instance.
  #
  # package - The String that identifies the type of package.
  # version - The String used to indicate the version.
  # date    - The Time when the release was made.
  # files   - The Array of File included in this release.
  # notes   - The String containg notes about the release.
  #
  # Returns a Release instance.
  def initialize(package, version, date, files, notes)
    @package = package
    @version = version
    @date    = date
    @files   = files
    @notes   = notes
  end

  class File
    attr_reader :filename, :size, :md5, :kind

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

    # Internal: Build a File instance.
    #
    # filename - The String used to represent the file of a Release.
    # size     - The Integer that represents the size (in bytes) of the file.
    # md5      - The String that serves as checksum.
    # kind     - The Symbol that identifies the type of File.
    #
    # Returns a Release instance.
    def initialize(filename, size, md5, kind)
      @filename = filename
      @size     = size
      @md5      = md5
      @kind     = kind
    end

    # Public: Identify the file as a installer package.
    #
    # Returns true or false.
    def installer?
      @kind == :installer
    end

    # Public: Identify the file as binary package (7-zip).
    #
    # Returns true or false.
    def binary?
      @kind == :binary
    end

    # Public: Identify the file as documentation package (CHM).
    #
    # Returns true or false.
    def documentation?
      @kind == :documentation
    end

    # Public: Identify the file as DevKit package (SFX)
    #
    # Returns true or false.
    def devkit?
      @kind == :devkit
    end
  end
end

# initial load of releases
Release.reload!
