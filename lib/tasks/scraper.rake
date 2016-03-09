require 'open-uri'

namespace :scraper do
  desc "Scraping of the products description from the motul-com"
  task load_products: :environment do
    ScrapedProduct.delete_all
    begin
      path = '/ru/ru/products/oils-lubricants'
      begin
        path = scrape_products_list('https://www.motul.com', path)
      end until !path
    rescue => e
      puts e.message
    end
  end

  def scrape_product(host, path)
    uri = host + path

    print "-- open the product page with URI '#{uri}'... "
    html = Nokogiri::HTML(open(uri))
    puts "ok"

    product = ScrapedProduct.new

    print '   [page_uri] '
    product.page_uri = uri

    print '[name] '
    product.name = html.css('h1.product-details-title').text

    html.css('div.product-details-specs').css('tr').each do |tr|
      case tr.css('td.criteria').text
      when 'Применение:'
        print '[application] '
        product.application = tr.css('td.value').text
      when 'Тип двигателя:'
        print '[engine_type] '
        product.engine_type = tr.css('td.value').text
      when 'Качество:'
        print '[quality] '
        product.quality = tr.css('td.value').text
      when 'Ассортимент продукции:'
        print '[category] '
        product.category = tr.css('td.value').text
      when 'Вязкость:'
        print '[viscosity] '
        product.viscosity = tr.css('td.value').text
      when 'ACEA Стандарты:'
        print '[acea] '
        product.acea = tr.css('td.value').text
      when 'API Стандарты:'
        print '[api] '
        product.api = tr.css('td.value').text
      when 'Одобрения :'
        print '[homologation] '
        product.homologation = tr.css('td.value').text
      end
    end

    if html.css('.products-tags-dpf').present?
      print '[dpf] '
      product.is_dpf = true;
    end

    if html.css('.products-tags-fuel_eco').present?
      print '[fuel_eco] '
      product.is_fuel_eco = true;
    end

    html.css('a.document-link').each do |pdf_link|
      if pdf_link.text == 'Техническая информация'
        print '[pdf_uri] '
        product.pdf_uri = host + pdf_link[:href]

        io = open(product.pdf_uri)
        reader = PDF::Reader.new(io)
        reader.pages.each do |page|
          product.pdf_text = String.new unless product.pdf_text
          product.pdf_text << page.text
        end
        #puts product.pdf_text.delete!("\n")
      end
    end

    puts '[img_uri] '
    img_css = html.at_css('a.product-image-large')
    if img_css != nil
      product.img_uri = img_css[:href]
    end
    img_css = html.at_css('div.product-image-large') unless img_css
    if img_css != nil
      product.img_uri = img_css.at_css('img')[:src]
    end

    product.save
  end

  def scrape_products_list(host, path)
    uri = host + path

    print "Open the products list page with URI '#{uri}'... "
    html = Nokogiri::HTML(open(uri))
    puts "success"

    html.css('.products-list-item').each do |a|
      scrape_product(host, a[:href])
    end

    html.at_css('.next_page')[:href]
  end
end
