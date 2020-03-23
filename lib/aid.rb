require_relative "aid/version"

module Aid
  def self.load_paths
    @load_paths ||= [
      File.expand_path(File.dirname(__FILE__) + "/aid/scripts"),
      ".aid",
      "#{Aid.project_root}/.aid",
      ENV['AID_PATH']
    ].compact
  end

  def self.load_scripts!
    load_paths.each do |path|
      Dir.glob("#{path}/**/*.rb").each do |file|
        require File.expand_path(file)
      end
    end
  end

  def self.script_name
    ARGV.first
  end

  def self.script_args
    ARGV[1..-1]
  end

  def self.project_root
    @project_root ||= begin
      current_search_dir = Dir.pwd

      loop do
        git_index = "#{current_search_dir}/.git"
        git_index_exists = Dir.exists?(git_index) || File.exists?(git_index)

        return current_search_dir if git_index_exists
        break if current_search_dir == "/"

        current_search_dir = File.expand_path("#{current_search_dir}/..")
      end

      nil
    end
  end
end

require_relative "aid/colorize"
require_relative "aid/inheritable"
require_relative "aid/script"
require_relative "aid/scripts"
