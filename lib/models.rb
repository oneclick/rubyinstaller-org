require "psych"
require "time"

class Release < Struct.new(:package, :version, :date, :files, :notes)
  private_class_method :new

  def self.loaded
    @@loaded ||= []
  end

  def self.reload!(data_dir = nil)
    data_dir ||= ::File.expand_path("../../data", __FILE__)

    files = Dir.glob("#{data_dir}/releases/**/*.yml")

    @@loaded = files.collect { |f| from_file(f) }

    !@@loaded.empty?
  end

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

  class File < Struct.new(:filename, :size, :md5, :kind)
    private_class_method :new

    def self.from_hash(data)
      filename = data.fetch("filename")
      size     = data.fetch("size")
      md5      = data.fetch("md5")
      kind     = data.fetch("kind").to_sym

      new filename, size, md5, kind
    end
  end
end
