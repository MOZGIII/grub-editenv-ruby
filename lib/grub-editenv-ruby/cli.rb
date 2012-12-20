require 'optparse'
require 'grub-editenv-ruby'

module GrubEditEnv
  class Cli
    DEFAULT_PATH = "/boot/grub/grubenv"
    
    def self.start
      options = {}
      opts = OptionParser.new do |opts|        
        opts.banner = <<BANNER
SYNOPSIS
       grub-editenv-ruby [OPTIONS] [FILENAME] COMMAND

DESCRIPTION
       Tool to edit environment block.

   Commands:
       create create a blank environment block file

       list   list the current variables

       set [name=value ...]
              set variables

       unset [name ....]
              delete variables

OPTIONS
       -h, --help
              display this message and exit

       -V, --version
              print version information and exit

       -v, --verbose
              print verbose messages

       If not given explicitly, FILENAME defaults to #{DEFAULT_PATH}.
BANNER

      end.parse!
      
      cli = self.new
      
      if ARGV.empty?
        puts "You must specify a command! Pass --help for more details."
        exit 1
      end
      
      cli.filename = ARGV.size == 1 || ARGV[1] =~ /=/ ? nil : ARGV.shift
      cli.command = ARGV.shift.to_sym
      cli.arguments = ARGV
      cli.options = options
      
      method = cli.public_method(cli.command) rescue nil
      unless method
        puts "Not implemeted!"
        exit 1
      end
      
      method.call
    end
    
    attr_accessor :command, :arguments, :filename, :options  
    
    def create
      grubenv_build.dump
    end
    
    def list
      grubenv_build.entries.each do |key, value|
        puts "#{key}=#{value}"
      end
    end
    
    def set
      grubenv = grubenv_build
      
      arguments.each do |argument|
        key, value = argument.split("=")
        grubenv.entries[key] = value
      end
      
      grubenv.dump
    end
    
    def unset
      grubenv = grubenv_build
      
      arguments.each do |argument|
        grubenv.entries.delete(argument)
      end
      
      grubenv.dump
    end
    
    private
    
    def grubenv_build
      begin
        grubenv_build!
      rescue GrubEnv::FileNotFound => e
        puts e
        exit 1
      end
    end
    
    def grubenv_build!
      GrubEnv.new(:grubenv_path => filename || DEFAULT_PATH)
    end
  end
end
