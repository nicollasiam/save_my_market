namespace :execute do
  desc "Run all run_all_registrations_crawlers"
  task run_all_registrations_crawlers: :environment do
    dia_start = Time.now
    puts "Início Dia: #{dia_start}"
    Crawlers::Dia::RegistrationCrawler.execute
    dia_end = Time.now
    puts "Fim Dia: #{dia_end}"
    dia_elapsed = dia_end - dia_start
    hours = ((dia_elapsed / 60) / 60).to_i
    minutes = ((dia_elapsed / 60) % 60).to_i
    seconds = (dia_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Dia: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    mambo_start = Time.now
    puts "\nInício Mambo: #{mambo_start}"
    Crawlers::Mambo::RegistrationCrawler.execute
    mambo_end = Time.now
    puts "Fim Mambo: #{mambo_end}"
    mambo_elapsed = mambo_end - mambo_start
    hours = ((mambo_elapsed / 60) / 60).to_i
    minutes = ((mambo_elapsed / 60) % 60).to_i
    seconds = (mambo_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Mambo: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    home_refill_start = Time.now
    puts "\nInício Home Refill: #{home_refill_start}"
    Crawlers::HomeRefill::RegistrationCrawler.execute
    home_refill_end = Time.now
    puts "Fim Home Refill: #{home_refill_end}"
    home_refill_elapsed = home_refill_end - home_refill_start
    hours = ((home_refill_elapsed / 60) / 60).to_i
    minutes = ((home_refill_elapsed / 60) % 60).to_i
    seconds = (home_refill_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Home Refill: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    extra_start = Time.now
    puts "\nInício Extra: #{extra_start}"
    Crawlers::Extra::RegistrationCrawler.execute
    extra_end = Time.now
    puts "Fim Extra: #{extra_end}"
    extra_elapsed = extra_end - extra_start
    hours = ((extra_elapsed / 60) / 60).to_i
    minutes = ((extra_elapsed / 60) % 60).to_i
    seconds = (extra_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Extra: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    carrefour_start = Time.now
    puts "\nInício Carrefour: #{carrefour_start}"
    Crawlers::Carrefour::RegistrationCrawler.execute
    carrefour_end = Time.now
    puts "Fim Carrefour: #{carrefour_end}"
    carrefour_elapsed = carrefour_end - carrefour_start
    hours = ((carrefour_elapsed / 60) / 60).to_i
    minutes = ((carrefour_elapsed / 60) % 60).to_i
    seconds = (carrefour_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Carrefour: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    pao_de_acucar_start = Time.now
    puts "\nInício Pão de Açucar: #{pao_de_acucar_start}"
    Crawlers::PaoDeAcucar::RegistrationCrawler.execute
    pao_de_acucar_end = Time.now
    puts "Fim Pão de Açucar: #{pao_de_acucar_end}"
    pao_de_acucar_elapsed = pao_de_acucar_end - pao_de_acucar_start
    hours = ((pao_de_acucar_elapsed / 60) / 60).to_i
    minutes = ((pao_de_acucar_elapsed / 60) % 60).to_i
    seconds = (pao_de_acucar_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Pão de Açucar: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    sonda_start = Time.now
    puts "\nInício Sonda: #{sonda_start}"
    Crawlers::Sonda::RegistrationCrawler.execute
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

  desc "Run all run_all_update_crawlers"
  task run_all_update_crawlers: :environment do
    dia_start = Time.now
    puts "Início Dia: #{dia_start}"
    Crawlers::Dia::UpdateCrawler.execute
    dia_end = Time.now
    puts "Fim Dia: #{dia_end}"
    dia_elapsed = dia_end - dia_start
    hours = ((dia_elapsed / 60) / 60).to_i
    minutes = ((dia_elapsed / 60) % 60).to_i
    seconds = (dia_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Dia: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    # mambo_start = Time.now
    # puts "\nInício Mambo: #{mambo_start}"
    # Crawlers::Mambo::UpdateCrawler.execute
    # mambo_end = Time.now
    # puts "Fim Mambo: #{mambo_end}"
    # mambo_elapsed = mambo_end - mambo_start
    # hours = ((mambo_elapsed / 60) / 60).to_i
    # minutes = ((mambo_elapsed / 60) % 60).to_i
    # seconds = (mambo_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    # puts "Mambo: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    home_refill_start = Time.now
    puts "\nInício Home Refill: #{home_refill_start}"
    Crawlers::HomeRefill::UpdateCrawler.execute
    home_refill_end = Time.now
    puts "Fim Home Refill: #{home_refill_end}"
    home_refill_elapsed = home_refill_end - home_refill_start
    hours = ((home_refill_elapsed / 60) / 60).to_i
    minutes = ((home_refill_elapsed / 60) % 60).to_i
    seconds = (home_refill_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Home Refill: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    extra_start = Time.now
    puts "\nInício Extra: #{extra_start}"
    Crawlers::Extra::UpdateCrawler.execute
    extra_end = Time.now
    puts "Fim Extra: #{extra_end}"
    extra_elapsed = extra_end - extra_start
    hours = ((extra_elapsed / 60) / 60).to_i
    minutes = ((extra_elapsed / 60) % 60).to_i
    seconds = (extra_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Extra: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    carrefour_start = Time.now
    puts "\nInício Carrefour: #{carrefour_start}"
    Crawlers::Carrefour::UpdateCrawler.execute
    carrefour_end = Time.now
    puts "Fim Carrefour: #{carrefour_end}"
    carrefour_elapsed = carrefour_end - carrefour_start
    hours = ((carrefour_elapsed / 60) / 60).to_i
    minutes = ((carrefour_elapsed / 60) % 60).to_i
    seconds = (carrefour_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Carrefour: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    pao_de_acucar_start = Time.now
    puts "\nInício Pão de Açucar: #{pao_de_acucar_start}"
    Crawlers::PaoDeAcucar::UpdateCrawler.execute
    pao_de_acucar_end = Time.now
    puts "Fim Pão de Açucar: #{pao_de_acucar_end}"
    pao_de_acucar_elapsed = pao_de_acucar_end - pao_de_acucar_start
    hours = ((pao_de_acucar_elapsed / 60) / 60).to_i
    minutes = ((pao_de_acucar_elapsed / 60) % 60).to_i
    seconds = (pao_de_acucar_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "Pão de Açucar: #{hours} horas, #{minutes} minutos e #{seconds} segundos"

    sonda_start = Time.now
    puts "\nInício Sonda: #{sonda_start}"
    Crawlers::Sonda::UpdateCrawler.execute
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
    start_time = Time.now
    puts "\nCleaning invalid data: start at #{start_time}"
    Applications::TrashBot.trashify
    end_time = Time.now
    total_elapsed = end_time - start_time
    hours = ((total_elapsed / 60) / 60).to_i
    minutes = ((total_elapsed / 60) % 60).to_i
    seconds = (total_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "TEMPO TOTAL DECORRIDO: #{hours} horas, #{minutes} minutos e #{seconds} segundos"
  end

  desc 'Categorize all new Products'
  task categorize_products: :environment do
    start_time = Time.now
    puts "\nCategorizing: start at #{start_time}"
    Applications::CategorizeBot.categorize
    end_time = Time.now
    total_elapsed = end_time - start_time
    hours = ((total_elapsed / 60) / 60).to_i
    minutes = ((total_elapsed / 60) % 60).to_i
    seconds = (total_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "TEMPO TOTAL DECORRIDO: #{hours} horas, #{minutes} minutos e #{seconds} segundos"
  end

  desc 'Treat sick data'
  task fix_sick_data: :environment do
    start_time = Time.now
    puts "\nTreating: start at #{start_time}"
    Applications::NurseBot.treat_injuries
    end_time = Time.now
    total_elapsed = end_time - start_time
    hours = ((total_elapsed / 60) / 60).to_i
    minutes = ((total_elapsed / 60) % 60).to_i
    seconds = (total_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "TEMPO TOTAL DECORRIDO: #{hours} horas, #{minutes} minutos e #{seconds} segundos"
  end

  desc 'Update data'
  task update_analisys_data: :environment do
    start_time = Time.now
    puts "\nUpdating data: start at #{start_time}"
    Applications::DataUpdateBot.execute
    end_time = Time.now
    total_elapsed = end_time - start_time
    hours = ((total_elapsed / 60) / 60).to_i
    minutes = ((total_elapsed / 60) % 60).to_i
    seconds = (total_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
    puts "TEMPO TOTAL DECORRIDO: #{hours} horas, #{minutes} minutos e #{seconds} segundos"
  end

  desc 'Run all tasks'
  task run_all_tasks: [:environment,
                       'execute:run_all_registrations_crawlers',
                       'execute:run_all_update_crawlers',
                       'execute:clear_invalid_data',
                       'execute:fix_sick_data',
                       'execute:update_analisys_data',
                       'execute:categorize_products'
                      ]
end

desc 'Run Carrefour Crawlers'
task run_carrefour_crawlers: :environment do
  carrefour_start = Time.now
  puts "\nInício Carrefour: #{carrefour_start}"
  Crawlers::Carrefour::UpdateCrawler.execute
  carrefour_end = Time.now
  puts "Fim Carrefour: #{carrefour_end}"
  carrefour_elapsed = carrefour_end - carrefour_start
  hours = ((carrefour_elapsed / 60) / 60).to_i
  minutes = ((carrefour_elapsed / 60) % 60).to_i
  seconds = (carrefour_elapsed - (hours * 60 * 60) - (minutes * 60)).to_i
  puts "Carrefour: #{hours} horas, #{minutes} minutos e #{seconds} segundos"
end
