namespace :execute do
  desc "Run all run_all_crawlers"
  task run_all_crawlers: :environment do
    dia_start = Time.now
    puts "Início Dia: #{dia_start}"
    Crawlers::DiaCrawler.execute
    dia_end = Time.now
    puts "Fim Dia: #{dia_end}"
    dia_elapsed = dia_end - dia_start
    hours = ((dia_elapsed / 60) / 60).to_i
    minutes = ((dia_elapsed / 60) % 60).to_i
    seconds = (dia_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Dia: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    mambo_start = Time.now
    puts "Início Mambo: #{mambo_start}"
    Crawlers::MamboCrawler.execute
    mambo_end = Time.now
    puts "Fim Mambo: #{mambo_end}"
    mambo_elapsed = mambo_end - mambo_start
    hours = ((mambo_elapsed / 60) / 60).to_i
    minutes = ((mambo_elapsed / 60) % 60).to_i
    seconds = (mambo_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Mambo: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    home_refill_start = Time.now
    puts "Início Home Refill: #{home_refill_start}"
    Crawlers::HomeRefillCrawler.execute
    home_refill_end = Time.now
    puts "Fim Home Refill: #{home_refill_end}"
    home_refill_elapsed = home_refill_end - home_refill_start
    hours = ((home_refill_elapsed / 60) / 60).to_i
    minutes = ((home_refill_elapsed / 60) % 60).to_i
    seconds = (home_refill_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Home Refill: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    extra_start = Time.now
    puts "Início Extra: #{extra_start}"
    Crawlers::ExtraCrawler.execute
    extra_end = Time.now
    puts "Fim Extra: #{extra_end}"
    extra_elapsed = extra_end - extra_start
    hours = ((extra_elapsed / 60) / 60).to_i
    minutes = ((extra_elapsed / 60) % 60).to_i
    seconds = (extra_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Extra: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    carrefour_start = Time.now
    puts "Início Carrefour: #{carrefour_start}"
    Crawlers::CarrefourCrawler.execute
    carrefour_end = Time.now
    puts "Fim Carrefour: #{carrefour_end}"
    carrefour_elapsed = carrefour_end - carrefour_start
    hours = ((carrefour_elapsed / 60) / 60).to_i
    minutes = ((carrefour_elapsed / 60) % 60).to_i
    seconds = (carrefour_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Carrefour: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    pao_de_acucar_start = Time.now
    puts "Início Pão de Açucar: #{pao_de_acucar_start}"
    Crawlers::PaoDeAcucarCrawler.execute
    pao_de_acucar_end = Time.now
    puts "Fim Pão de Açucar: #{pao_de_acucar_end}"
    pao_de_acucar_elapsed = pao_de_acucar_end - pao_de_acucar_start
    hours = ((pao_de_acucar_elapsed / 60) / 60).to_i
    minutes = ((pao_de_acucar_elapsed / 60) % 60).to_i
    seconds = (pao_de_acucar_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Pão de Açucar: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    sonda_start = Time.now
    puts "Início Sonda: #{sonda_start}"
    Crawlers::sondaCrawler.execute
    sonda_end = Time.now
    puts "Fim Sonda: #{sonda_end}"
    sonda_elapsed = sonda_end - sonda_start
    hours = ((sonda_elapsed / 60) / 60).to_i
    minutes = ((sonda_elapsed / 60) % 60).to_i
    seconds = (sonda_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Sonda: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    total_elapsed = sonda_end - dia_start
    hours = ((total_elapsed / 60) / 60).to_i
    minutes = ((total_elapsed / 60) % 60).to_i
    seconds = (total_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "TEMPO TOTAL DECORRIDO: #{hours} horas, #{minutes} minutos e #{seconds} segundos"
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
