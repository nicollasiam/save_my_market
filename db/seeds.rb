# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Market.create!([{ :name => "Home Refill",
                 :logo => "https://lh3.googleusercontent.com/3gYY9yBzi1mDOxK-YPia66yti9-EwDPxdizeafLpjr6HSYoZBcva1Q65arXSLHt3FEM"
               },
               { :name => "Sonda",
                 :logo => "https://www.sondadelivery.com.br/scripts/img/sonda.png"
               },
               { :name => "Carrefour",
                 :logo => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVTXlGnxcEY1iVYbK_yvyuWtxfrcWAAqgX_cr8zAF6PEfwW8R2"
               },
               { :name => "Pão de Açucar",
                 :logo => "https://www.hservice.com.br/gerenciador/upload/1491322289.jpg"
               },
               { :name => "Dia",
                 :logo => "http://itimirim.com.br/wp-content/uploads/2016/04/Dia.jpg"
               },
               { :name => "Extra",
                 :logo => "http://marcioantunes2.cmisites.com.br/wp-content/uploads/sites/394/2017/12/extra.jpg"
               },
               { :name => "Mambo",
                 :logo => "https://mambo.vteximg.com.br/arquivos/mambo-logo-small.png"
               }])

Category.create!([{ name: 'butchery' },
                  { name: 'drinks' },
                  { name: 'alcoholic_drinks' },
                  { name: 'candy' },
                  { name: 'frozen_food' },
                  { name: 'frozen_food' },
                  { name: 'disposable' },
                  { name: 'cheese' },
                  { name: 'hygiene' },
                  { name: 'fruit_and_vegetables' },
                  { name: 'grocers' },
                  { name: 'beauty' },
                  { name: 'utensils' },
                  { name: 'other' }
                 ])
