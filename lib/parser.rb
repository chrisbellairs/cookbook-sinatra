require 'nokogiri'
require 'open-uri'

class Parser
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def top_five
    top_five = []
    file = open("https://www.allrecipes.com/search/?wt=#{@ingredient}")
    html_doc = Nokogiri::HTML(file)
    recipe_card = html_doc.css('div.fixed-recipe-card__info')
    recipe_card.each do |element|
      next if element.css('.stars.stars-5').attribute('data-ratingstars').nil?

      title = element.css('.fixed-recipe-card__h3').text.strip
      description = element.css('.fixed-recipe-card__description').text.strip
      rating = element.css('.stars.stars-5').attribute('data-ratingstars').value.to_i.round
      recipe_url = element.search(".fixed-recipe-card__title-link").first.attribute("href").value
      prep_time = prep_time(recipe_url)
      top_five << [title, description, rating, prep_time] unless top_five.length == 5
    end
    top_five
  end

  private

  def prep_time(url)
    recipe_html = open(url).read
    recipe_doc = Nokogiri::HTML(recipe_html, nil, "utf-8")
    recipe_doc.search(".recipe-meta-item-body").first.text.strip
  end
end
