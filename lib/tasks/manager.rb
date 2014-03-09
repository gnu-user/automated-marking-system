
class Manager
    attr_accessor :path_to_file, :output

    def initialize(path='')
        @path_to_file = path
    end

    def checkFileExist
      File.exist?(@path_to_file)
    end

    def process
      unless checkFileExist
        puts 'File not found'
        Array.new
      end
    end

    def parseOutput

    end
end