#!/usr/bin/env ruby
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

require 'rubygems'
require 'bundler/setup'
require 'quiz.rb'

VERSION = 0.1

USAGE = <<ENDUSAGE
Uso:
  genquiz -o <archivo_de_salida> [lista de archivos de preguntas]
ENDUSAGE

HELP = <<ENDHELP
  -h, --help     Mostrar esta ayuda
  -v, --version  Mostrar el número de versión
  -o, --output   El fichero donde se guardaran las preguntas
  -n, --number   Número de preguntas a generar

Ejemplos:
  genquiz -o -n 3 cuestionario.xml questions/cloze_addresses.rb 
  genquiz -o cuestionario.xml questions/*
ENDHELP

ARGS = { :output=>'quiz.xml', :number => 1, :files=>[] }
UNFLAGGED_ARGS = [ :files ]
next_arg = UNFLAGGED_ARGS.first
ARGV.each do |arg|
  case arg
    when '-h','--help'	then ARGS[:help] = true
    when '-v','--version' then ARGS[:version] = true
    when '-o','--output' then next_arg = :output
    when '-n','--number' then next_arg = :number
    else
      if next_arg
        if next_arg == :files
          ARGS[ :files ] << arg
        else
          ARGS[next_arg] = arg
        end
      end
      next_arg = UNFLAGGED_ARGS.first
  end
end

puts "genquiz v#{VERSION}" if ARGS[:version]

if ARGS[:help] or ARGS[:files].empty?
  puts USAGE unless ARGS[:version]
  puts HELP if ARGS[:help]
  exit
end

quiz = Quiz.new(ARGS[:number])

begin
  ARGS[:files].each do |file|
    question = nil
    puts "Processing '#{file}'"
    question = eval(File.open(file).read)
    if question.is_a?(Hash)
      puts question[:name]
      quiz.add(question)
    else
      raise "question hash not found in '#{file}'"
    end
  end
  File.write(ARGS[:output], quiz)
  puts "Quiz generated correctly in '#{ARGS[:output]}'"

rescue Exception => e
  puts "Error: #{e.message}"
  puts e.backtrace
  exit
end

