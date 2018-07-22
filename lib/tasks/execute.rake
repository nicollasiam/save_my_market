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

    mambo_start = Time.now
    Crawlers::MamboCrawler.execute
    mambo_end = Time.now
    puts "Fim Mambo: #{mambo_end}"
    mambo_elapsed = mambo_end - mambo_start
    puts "Mambo: #{((mambo_elapsed / 60) / 60).to_i} horas, #{(mambo_elapsed / 60).to_i} minutos e #{(mambo_elapsed % 60).to_i} segundos"

    home_refill_start = Time.now
    Crawlers::HomeRefillCrawler.execute
    home_refill_end = Time.now
    puts "Fim Home Refill: #{home_refill_end}"
    home_refill_elapsed = home_refill_end - home_refill_start
    puts "Home Refill: #{((home_refill_elapsed / 60) / 60).to_i} horas, #{(home_refill_elapsed / 60).to_i} minutos e #{(home_refill_elapsed % 60).to_i} segundos"

    extra_start = Time.now
    # Crawlers::ExtraCrawler.execute
    # extra_end = Time.now
    # puts "Fim Extra: #{extra_end}"
    # extra_elapsed = extra_end - extra_start
    # puts "Extra: #{((extra_elapsed / 60) / 60).to_i} horas, #{(extra_elapsed / 60).to_i} minutos e #{(extra_elapsed % 60).to_i} segundos"

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

  desc 'Clear all invalid data'
  task clear_invalid_data: :environment do
    Applications::TrashBot.trashify
  end

  desc 'Run all tasks'
  task run_all_tasks: [:environment,
                       'execute:run_all_crawlers',
                       'execute:clear_invalid_data'
                      ]
end
