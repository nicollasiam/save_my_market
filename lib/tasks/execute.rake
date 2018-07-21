namespace :execute do
  desc "Run all run_all_crawlers"
  task run_all_crawlers: :environment do
    Crawlers::DiaCrawler.execute
    # Crawlers::MamboCrawler.execute
    # Crawlers::HomeRefillCrawler.execute
    # Crawlers::HirotaCrawler.execute
    # Crawlers::ExtraCrawler.execute
    Crawlers::CarrefourCrawler.execute
    Crawlers::PaoDeAcucarCrawler.execute
  end

end
