require 'yaml'
require 'i18n'

# Protect from insults words
class InsultsFilterService

  def self.execute(words)
    new(words)
  end

  def initialize(words)
    I18n.available_locales = [:fr]
    I18n.locale = :fr
    @words = words
  end

  def safe?
    @insults = YAML.load(
      File.read(File.expand_path('data/insults.fr.yml', File.dirname(__FILE__)))
    )

    @words.all? do |word|
      sanitized_word = I18n.transliterate(word).tr('-', ' ')

      !@insults.include?(sanitized_word) &&
        !sanitized_word.match(/^(([a-zA-Z0-9|\s]){,15})$/u).nil?
    end
  end

end
