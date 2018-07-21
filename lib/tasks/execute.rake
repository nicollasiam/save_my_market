namespace :execute do
  desc "Run all run_all_crawlers"
  task run_all_crawlers: :environment do
    dia_start = Time.now
    puts "Início Dia: #{dia_start}"
    Crawlers::DiaCrawler.execute
    dia_end = Time.now
    puts "Fim Dia: #{dia_end}"
    dia_elapsed = dia_end - dia_start
    puts "Dia: #{((dia_elapsed / 60) / 60).to_i} horas, #{(dia_elapsed / 60).to_i} minutos e #{(dia_elapsed % 60).to_i} segundos"

    # Crawlers::MamboCrawler.execute
    # Crawlers::HomeRefillCrawler.execute
    # Crawlers::ExtraCrawler.execute

    carrefour_start = Time.now
    puts "Início Carrefour: #{carrefour_start}"
    Crawlers::CarrefourCrawler.execute
    carrefour_end = Time.now
    puts "Fim Carrefour: #{carrefour_end}"
    carrefour_elapsed = carrefour_end - carrefour_start
    puts "Carrefour: #{((carrefour_elapsed / 60) / 60).to_i} horas, #{(carrefour_elapsed / 60).to_i} minutos e #{(carrefour_elapsed % 60).to_i} segundos"

    pao_de_acucar_start = Time.now
    puts "Início Pão de Açucar: #{pao_de_acucar_start}"
    Crawlers::PaoDeAcucarCrawler.execute
    pao_de_acucar_end = Time.now
    puts "Fim Pão de Açucar: #{pao_de_acucar_end}"
    pao_de_acucar_elapsed = pao_de_acucar_end - pao_de_acucar_start
    puts "Pão de Açucar: #{((pao_de_acucar_elapsed / 60) / 60).to_i} horas, #{(pao_de_acucar_elapsed / 60).to_i} minutos e #{(pao_de_acucar_elapsed % 60).to_i} segundos"
  end

end
