# -*- coding:utf-8 -*-

require 'sinatra'
require 'nokogiri'
require 'haml'
require 'open-uri'

set :haml, format: :html5

get '/' do
  SOURCE_URI = 'http://zh.wikipedia.org/wiki/%E4%B8%AD%E5%8D%8E%E4%BA%BA%E6%B0%91%E5%85%B1%E5%92%8C%E5%9B%BD%E5%8E%BF%E7%BA%A7%E4%BB%A5%E4%B8%8A%E8%A1%8C%E6%94%BF%E5%8C%BA%E5%88%97%E8%A1%A8'
  MARKUP_CHANGED = 'Failed to find supposed element, maybe source markup changed and this application must update.'

  doc = Nokogiri::HTML(open(SOURCE_URI))
  data_node = doc.css('#mw-content-text')

  regions = {}

  doc.css('h3').each do |h3_el|

    province_el = h3_el.css('.mw-headline').first
    next if province_el.nil?

    province = province_el.content

    next unless province[/市|省|自治区|行政区/]
    regions[province] = []

    next unless province[/省|自治区/] # some region have no child

    table_el = h3_el.next_element
    next unless 'table'.eql?table_el.name

    table_el.css('tr').each_with_index do |tr_el, idx|
      next if 6 > idx # skip first 6 tr

      a_el = tr_el.css('th a').first
      next if a_el.nil?

      regions[province] << a_el.content
    end

  end # doc.css('h3').each

  regions['台湾地区'] = []
  regions['海外'] = []

  haml :index, locals: { content: regions.to_yaml  }
end
