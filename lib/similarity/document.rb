class Document

  attr_accessor :key, :terms, :content

  def initialize(text = "", terms = [])
    if (text.nil? || text.empty?) && terms.empty?
      raise ArgumentError, "text cannot be nil or blank"
    end
    
    @content = text
    @key = key
    @term_frequency = nil
    @terms = terms.any? ? terms.map { |term| term.downcase } : extract_terms
  end

  def extract_terms
    @terms ||=
      @content.to_s.gsub(/(\d|\s|\W)+/, ' ').
      split(/\s/).map { |term| term.downcase }
  end

  def term_frequencies
    @term_frequencies ||= calculate_term_frequencies
  end

  def calculate_term_frequencies
    tf = {}
    terms.each do |term|
      if tf[term]
        tf[term] += 1
      else
        tf[term] = 1
      end
    end
    total_number_of_terms = terms.size.to_f
    tf.each_pair { |k,v| tf[k] = (tf[k] / total_number_of_terms) }
  end

  def term_frequency(term)
    if tf = term_frequencies[term]
      tf
    else
      0
    end
  end

  def vector_space(corpus)
    vector_space = []
    vector_space_index = 0
    corpus.terms.each_pair do |term, count|
      if has_term?(term)
        vector_space[vector_space_index] = term_frequencies[term] * corpus.inverse_document_frequency(term)
      else
        vector_space[vector_space_index] = 0
      end
      vector_space_index += 1
    end
    vector_space
  end

  def has_term?(term)
    terms.include? term
  end
end
