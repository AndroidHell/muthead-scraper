require 'open-uri'
require 'nokogiri'
require 'json'

def pull
  
  page = 1
  id = 1
  
  1.upto(122) do |page|
    
    open("http://www.muthead.com/16/players?page=#{page}") do |f|
  
      doc = Nokogiri::HTML(f)
      puts doc.at_css("title").text
      table = doc.at_xpath('//table/tbody')
  
      players = []
      player = nil
      
      table.xpath('tr').each do |tr|
  
        td = tr.xpath('td')
        td = td.map { |td| td.content.gsub(/\r?\n/, ' ').split.first(2).join(' ') }
        td = td.select { |txt| not txt.empty? }
        next if td.empty?
  
        player = {
            'id'       => id,
            'name'     => td[0],
            'overall'  => td[1],
            'position' => td[2],
            'price'    => td[3]
        }
  
        id += 1
  
        players << player if player
        
      end
      
      puts JSON.pretty_generate(players)
    
      File.open("players.json", "a") do |f|
         f.write JSON.pretty_generate(players)
      end
      
      sleep 2
    end
    
    page += 1
    
  end
end
pull