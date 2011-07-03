require 'spruz/uniq_by'
require 'cpu/shared'
require 'cpu/processor'
require 'cpu/msr'
require 'cpu/load'
require 'cpu/usage_sampler'
require 'cpu/usage'

# This module provides (read) access to the Model Specific Registers of Intel
# CPUs on Linux.
module CPU
  class << self
    # The t_j_max temperature of that is used as a default for this Processor
    # if it cannot be queried (e.g. Core2 architecture). It defaults to 95
    # which is the correct value for Core2 Duo E8400 (Wolfsdale). Be sure to
    # set the correct value for your Core2 CPU here, otherwise your
    # temperature measurements will be incorrect.
    attr_accessor :t_j_max
  end
  self.t_j_max = 95

  # XXX
  class CPUError < StandardError; end

  # This exception is thrown if an invalid ProcessorId is queried.
  class InvalidProcessorIdError < CPUError; end

  # XXX
  class NoSampleDataError < CPUError; end

  class << self
    # The path to the modprobe binary which is used to load the required module
    # if necessary.
    attr_accessor :modprobe_path
  end
  self.modprobe_path = '/sbin/modprobe'

  class << self
    # Return an array of all Processor instances for this machine.
    def processors
      cpu_cores = {}
      cpuinfos = File.read('/proc/cpuinfo').chomp.split(/^$/)
      processor_ids =
        cpuinfos.map { |l| l[/processor\s*:\s*(\d+)/, 1].to_i rescue nil }
      core_ids = cpuinfos.map { |l| l[/core id\s*:\s*(\d+)/, 1].to_i rescue nil }
      processor_ids.zip(core_ids) do |processor_id, core_id|
        cpu_cores[processor_id] = core_id
      end
      processors = Dir.open('/dev/cpu').inject([]) do |ps, processor_id|
        processor_id =~ /\A\d+\Z/ or next ps
        ps << processor_id.to_i
      end
      processors.extend Spruz::UniqBy
      processors.sort!
      @num_processors = processors.size
      @num_cores      = cpu_cores.invert.size
      processors.map! do |processor_id|
        Processor.new(processor_id, cpu_cores[processor_id])
      end
    end

    def num_processors
      @num_processors or processors
      @num_processors
    end

    def num_cores
      @num_cores or processors
      @num_cores
    end

    alias to_a processors

    def each_core(&block)
      processors.uniq_by(&:core_id).each(&block)
    end

    def cores
      each_core.to_a
    end

    # Iterate over each Processor instance for this machine and yield to the
    # block for each of them.
    def each_processor(&block)
      processors.each(&block)
    end

    alias each each_processor

    include Enumerable

    def load
      Load.new
    end

    def usage(interval = 1)
      before_usage = UsageSampler.new
      if block_given?
        yield
      else
        sleep interval
      end
      after_usage = UsageSampler.new
      processors.each do |processor|
        processor.usage = after_usage.usages[processor.processor_id] -
          before_usage.usages[processor.processor_id]
      end
    end

    def sum_usage_processor(interval = 1)
      processors = usage(interval)
      processor = Processor.new -1, -1
      processor.num_processors = processor.num_cores = 1
      processor.temperature = processors.map(&:temperature).max
      processor.usage = processors.map(&:usage).inject { |s, u| s + u }
      processor.usage.num_processors = processor.usage.num_cores = 1
      processor.freeze
      processor
    end
  end
end
