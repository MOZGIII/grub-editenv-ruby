module GrubEditEnv
  class GrubEnv
    class FileNotFound < Exception; end
  
    ENVBLK_SIGNATURE = "# GRUB Environment Block\n"
    ENVBLK_SIZE	= 1024
    
    def self.default_options
      {
        :envblk_signature => ENVBLK_SIGNATURE,
        :envblk_size => ENVBLK_SIZE,
        :grubenv_path => nil
      }
    end
    
    attr_reader :options
    attr_reader :entries
  
    def initialize(options = {})
      @options = self.class.default_options.merge(options)
      
      raise "Misconfigured" unless grubenv_path
      raise FileNotFound, "File #{grubenv_path} was not found!" unless File.file?(grubenv_path)
      
      reload
    end
    
    def grubenv_path
      options[:grubenv_path]
    end
    
    def reload
      @entries = nil
      data = File.read(grubenv_path)
      raise "Wrong grubenv format on reload!" unless data.start_with?(options[:envblk_signature])
      data[0, options[:envblk_signature].size] = ''
      data.sub!(/#*\z/, "")
      
      @entries = {}
      data.split("\n").each do |line|
        key, value = line.split("=")
        @entries[key] = value
      end
    end
    
    def dump
      contents = options[:envblk_signature]
      
      @entries.each do |key, value|
        data = "#{key}=#{value}\n"
        contents << data
      end
      
      contents << "#" while contents.size < options[:envblk_size]
    
      File.open grubenv_path, "wb" do |f|
        f << contents
      end
    end
  end
end