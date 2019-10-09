require 'nokogiri'
require 'curb'

# with threading it takes 16s, without more then 50s
pages = []
threads = []
i=1
main_url = "https://www.hive.co.uk/Search/Books/Fiction/Classic-fiction-pre-c-1945-?fq=01120-1200001934-1219341954&pg"
while (i!=1718) do
pages << main_url + "=#{i}"
i+=1
end
for page in pages
page_with_info =  Curl.get(page).body_str
html_page_with_info = Nokogiri::HTML(page_with_info)
threads1 = []
items = []
html_page_with_info.xpath('//a[@class="jacket-Book"]').each do |name|
      link = "https://www.hive.co.uk" + name[:href]
      items << link
end
hash_array = []
for item in items
  threads1 << Thread.new(item) do |url|
    html_item_page = Nokogiri::HTML(Curl.get(url).body_str)
    #puts html_item_page
    html_item_page.xpath('//div[@class = "titleAvailability"]/h1').each do |title|
      options = { url: url, name: title.text }
      hash_array << options
    end
  end
end
threads1.each {|thread| thread.join}
puts hash_array.inspect
end

#html_page_with_info.xpath('//span[@id="producTitle"]').each do |name|
#  puts name
#end
