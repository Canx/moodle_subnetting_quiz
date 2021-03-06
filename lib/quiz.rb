#!/usr/bin/env ruby

require 'question_factory.rb'
require 'builder'

# Quiz class

class Quiz

  def initialize(items = 1)
    @items = items
    @questions = Array.new
    @xml = Builder::XmlMarkup.new( :indent => 2 )
  end

  def add(question_hash)
    question_hash[:num] = @items

    (1..@items.to_i).each do |id|
      question_hash[:id] = id
      question_factory = QuestionFactory.new(question_hash)
      question = question_factory.create()
      @questions << question
    end
  end

  def to_s
    output = @xml.quiz do |xml_quiz|
      @questions.each do |question|
        question.to_xml(xml_quiz)
      end
    end
  end
end
