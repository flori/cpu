module CPU
  module Shared
    # Returns the number of processors in this computer
    def num_processors
      if @num_processors
        @num_processors
      else
        CPU.num_processors
      end
    end

    attr_writer :num_processors

    # Returns the number of cores in this computer
    def num_cores
      if @num_cores
        @num_cores
      else
        CPU.num_cores
      end
    end

    attr_writer :num_cores
  end
end
