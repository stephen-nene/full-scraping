require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'pry'

require_relative './course.rb'

class Scraper

  def get_page
    response = Net::HTTP.get_response(URI("http://learn-co-curriculum.github.io/site-for-scraping/courses"))
    doc = Nokogiri::HTML(response.body)

  end

  def get_courses
    self.get_page.css(".post")
  end

  def make_courses
    self.get_courses.each do |post|
      course = Course.new
      course.title = post.css("h2").text
      course.schedule = post.css(".date").text
      course.description = post.css("p").text
    end
  end

  def print_courses
    self.make_courses
    Course.all.each do |course|
      if course.title && course.title != ""
        puts "Title: #{course.title}"
        puts "  Schedule: #{course.schedule}"
        puts "  Description: #{course.description}"
      end
    end
  end

end

Scraper.new.print_courses


