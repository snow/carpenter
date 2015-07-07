#!/usr/bin/env ruby

require 'nokogiri'
require 'yaml'
require 'pp'
require 'open-uri'

doc = Nokogiri::HTML open 'http://www.stats.gov.cn/tjsj/tjbz/xzqhdm/201504/t20150415_712722.html'
INDENT_REGX = /　+/ # unicode space

regions = {}
current_province = nil
current_city = nil

doc.at_css('.TRS_PreAppend').css('.MsoNormal').each do |p|
  code = p.at_css('span:first').content[/\d+/]
  content = p.at_css('span:last').content
  begin
    indent = content[INDENT_REGX].length
  rescue NoMethodError
    puts p
    next
  end
  content = content.gsub INDENT_REGX, ''

  case indent
  when 1
    current_province = {
      name: content,
      children: {}
    }
    regions[code] = current_province
  when 2
    if content =~ /^(市辖区|县|省直辖县级行政区划)$/
      current_city = current_province
    else
      current_city = {
        name: content,
        children: {}
      }
      current_province[:children][code] = current_city
    end
  when 3
    next if content =~ /^(市辖区|县)$/
    current_city[:children][code] = {
      name: content
    }
  else
    puts span
  end
end

# add malform data manually
regions['130000'][:children]['130100'][:children]['130111'] = { name: '栾城区' }
regions['130000'][:children]['130100'][:children]['130181'] = { name: '辛集市' }
regions['130000'][:children]['130600'][:children]['130682'] = { name: '定州市' }

File.open('cache.yaml', 'w'){ |f| f.write regions.to_yaml }
puts 'done'
