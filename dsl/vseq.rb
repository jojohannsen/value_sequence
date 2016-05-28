require_relative '../lib/value_sequence'

Gem.find_files("./dsl/*.rb").each { |path| require path }

class Dsl
  def initialize
    @prompt = ""
    @sequences = {}
    @current_sequence = nil
    @dataSources = []
    @creators = {}
    @filters = []
    @transformers = []
    @creators["line"] = RegexValueCreator.new(/[\n\r]/, /[^[\n\r]]/)
    @creators["word"] = RegexValueCreator.new(/[^[\w]]/, /[\w]/)
    @failures = []
    @numberExpectations = 0
  end

  def xline(data)
    if (data.length > 1) then
      n = data[0].to_i
      if (n > 0) then
        return n,data[1..(data.length-1)].join(" ")
      end
    end
    return 1,data[0..(data.length-1)].join(" ")
  end


  def run(file, showline)
    @lineNumber = 0
    begin
      print "#{@prompt}"
      while (line = file.readline) do
        @lineNumber += 1
        line.chomp!
        puts line if (showline)
        data = line.split
        nval,line = xline(data)
        (1..nval).each do |n|
          puts process(line)
        end
        print "#{@prompt}"
      end
    rescue EOFError
    end
    results
  end

  def expect(value)
    @numberExpectations += 1
    comparison_value = value
    if (@lastVal.is_a? Numeric) then
      comparison_value = value.to_i
    end
    if (comparison_value != @lastVal) then
      failure = "#{@lineNumber}: expected #{value}, got #{@lastVal}"
      @failures << failure
      "FAILURE: #{failure}"
    else
      "Passed"
    end
  end

  def process(line)
    data = line.split
    if (data.length > 0)
      command = data[0].downcase
      case command
        when "quit"
          exit
        when "run"
          run(File.open(data[1], "r"), true)
        when "sequence"
          newSequence(data[1])
        when "string"
          data = line.split(" ", 2)
          str = eval(data[1])
          @current_sequence.addStringDataSource(str)
        when "file"
          data = line.split(" ", 2)
          str = eval(data[1])
          @current_sequence.addFileDataSource(str)
        when "by"
          if (data[1] == "sequence") then
            @current_sequence.setCreator(SequenceValueCreator.new(@sequences[data[2]], @sequences[data[3]]))
          else
            @current_sequence.setCreator(@creators[data[1]])
          end
        when "to"
          if (data[1] == "number") then
            @current_sequence.setTransformer(StringToNumber.new)
          end
        when "expect"
          expect(data[1])
        when "next"
          val = @current_sequence.nextValue
          if (val == nil) then
            @lastVal = val = "nil"
          else
            @lastVal = val.value
            val
          end
      end
    end
  end

  # sequence
  def newSequence(sequenceName)
    if (!@sequences.has_key?(sequenceName)) then
      @sequences[sequenceName] = ValueSequence.new
    end
    @current_sequence = @sequences[sequenceName]
  end

  # prompt "promptstr"
  def setPrompt(prompt)
    @prompt = prompt
  end

  def results
    if (@failures.length > 0) then
      puts "TESTS FAILED!  Failure count: #{@failures.length} "
      @failures.each do |failure|
        puts "  #{failure}"
      end
    else
      puts "#{@numberExpectations} tests, All tests passed"
    end
  end
end

dsl = Dsl.new

file = STDIN
showCommand = false
if (ARGV.length > 1) then
  file = File.open(ARGV[0], "r")
  showCommand = true
else
  dsl.setPrompt("> ")
end

dsl.run(file, showCommand)
dsl.results