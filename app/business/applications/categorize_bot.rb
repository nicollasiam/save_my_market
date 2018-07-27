module Applications
  class CategorizeBot
    BUTCHERY_MODEL = Category.find_by(name: 'butchery')
    DRINKS_MODEL = Category.find_by(name: 'drinks')
    ALCOHOLIC_DRINKS_MODEL = Category.find_by(name: 'alcoholic_drinks')
    CANDY_MODEL = Category.find_by(name: 'candy')
    FROZEN_FOOD_MODEL = Category.find_by(name: 'frozen_food')
    DISPOSABLE_MODEL = Category.find_by(name: 'disposable')
    CHEESE_MODEL = Category.find_by(name: 'cheese')
    HYGIENE_MODEL = Category.find_by(name: 'hygiene')
    FRUIT_AND_VEGETABLES_MODEL = Category.find_by(name: 'fruit_and_vegetables')
    GROCERS_MODEL = Category.find_by(name: 'grocers')
    BEAUTY_MODEL = Category.find_by(name: 'beauty')
    UTENSILS_MODEL = Category.find_by(name: 'utensils')
    OTHER_MODEL = Category.find_by(name: 'other')


    class << self
      def categorize
        products = Product.where(category_id: nil)

        products.each do |product|
          categorize_acougue(product)
          categorize_bebidas(product) if product.category.nil?
          categorize_bebidas_alcoolicas(product) if product.category.nil?
          categorize_doces(product) if product.category.nil?
          categorize_congelados(product) if product.category.nil?
          categorize_descartaveis(product) if product.category.nil?
          categorize_queijos_e_frios(product) if product.category.nil?
          categorize_higiene(product) if product.category.nil?
          categorize_hortifruti(product) if product.category.nil?
          categorize_mercearia(product) if product.category.nil?
          categorize_beleza(product) if product.category.nil?
          categorize_utensilios(product) if product.category.nil?
          categorize_outros(product) if product.category.nil?

          # puts "#{product.name} CATEGORIZADO" if product.category
          # puts "ERRO AO CATEGORIZAR PRODUTO #{product.name}" if product.category.nil?
        end
      end

      private

      def categorize_acougue(product)
        acougue_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = BUTCHERY_MODEL
            product.save
            break
          end
        end
      end

      def categorize_bebidas(product)
        bebidas_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = DRINKS_MODEL
            product.save
            break
          end
        end
      end

      def categorize_bebidas_alcoolicas(product)
        bebidas_alcoolicas_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = ALCOHOLIC_DRINKS_MODEL
            product.save
            break
          end
        end
      end

      def categorize_doces(product)
        doces_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = CANDY_MODEL
            product.save
            break
          end
        end
      end

      def categorize_congelados(product)
        congelados_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = FROZEN_FOOD_MODEL
            product.save
            break
          end
        end
      end

      def categorize_descartaveis(product)
        descartaveis_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = DISPOSABLE_MODEL
            product.save
            break
          end
        end
      end

      def categorize_queijos_e_frios(product)
        queijos_e_frios_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = CHEESE_MODEL
            product.save
            break
          end
        end
      end

      def categorize_higiene(product)
        higiene_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = HYGIENE_MODEL
            product.save
            break
          end
        end
      end

      def categorize_hortifruti(product)
        hortifruti_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = FRUIT_AND_VEGETABLES_MODEL
            product.save
            break
          end
        end
      end

      def categorize_mercearia(product)
        mercearia_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = GROCERS_MODEL
            product.save
            break
          end
        end
      end

      def categorize_beleza(product)
        beleza_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = BEAUTY_MODEL
            product.save
            break
          end
        end
      end

      def categorize_utensilios(product)
        utensilios_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = UTENSILS_MODEL
            product.save
            break
          end
        end
      end

      def categorize_outros(product)
        outros_key_words.each do |key_word|
          if product.name.downcase.include?(key_word)
            product.category = OTHER_MODEL
            product.save
            break
          end
        end
      end

      def acougue_key_words
        ['salsicha', 'linguiça', 'frango', 'costela', 'bovina', 'bovino', 'charque', 'contra filé', 'camarão', 'bacon', 'carne',
         'sobrecoxa', 'hambúrguer', 'asa', 'coxa', 'bacalhau', 'sardinha', 'kani', 'peixe', 'espinha', 'linguado', 'abadejo',
         'coração', 'tilápia', 'merluza', 'salmão', 'lagosta', 'mexilhão', 'porco', 'lombo', 'suíno', 'suína' 'lula', 'polvo',
         'picanha', 'alcatra', 'maminha', 'kafta', 'maturatta', 'pato', 'fraldinha', 'asinha', 'acém', 'pernil', 'chorizo', 'paio',
         'abrotea'
        ]
      end

      def bebidas_key_words
        ['coca', 'cocacola', 'coca-cola', 'água', 'dolce', 'solúvel', 'energético', 'espresso', 'isotônico', 'nescau', 'suco', 'nectar',
         'chá',  'fanta', 'guaraná', 'leite', 'café', 'toddynho', 'kuat', 'refrigerante', 'toddy', 'refresco', 'schweppes',
         'sprite', 'ades', 'h2oh', 'h2oh!', 'pepsi', 'gatorade'
        ]
      end

      def bebidas_alcoolicas_key_words
        ['cerveja', 'vodka', 'whisky', 'catuaba', 'vinho', 'espumante', 'licor', 'saque', 'saquê', 'cachaça', 'conhaque', 'tequila',
         'aperol', 'rum', 'gin', 'champagne', 'long neck', 'chandon', 'chandom', 'whysky', 'whiskey', 'whiky', 'vermouth', 'vermute',
         'absolut', 'aguardente', 'aguardardente'
        ]
      end

      def doces_key_words
        ['bombom',  'chocolate', 'leite condensado', 'sorvete', 'gelatina', 'geléia', 'bolo', 'bala', 'panetone' 'chichlete',
         'creme de leite', 'bis', 'goiabada', 'doce', 'paçoca', 'creme de avelã', 'chantily', 'confeito', 'granulado', 'cobertura',
         'marshmallow', 'mel', 'páscoa', 'pão de mel', 'alfajor', 'flan', 'brigadeiro', 'cocada', 'confeitaria', 'fondant',
         'pé de moleque', 'mousse', 'abacaxi em calda', 'abacaxi fatiado em calda', 'wafer', 'waffle', 'torta', 'figo em calda'
        ]
      end

      def congelados_key_words
        ['açai', 'açaí', 'nugget', 'pão de queijo', 'pizza', 'congelado', 'congelada', 'frooty', 'yakissoba', 'yakisoba']
      end

      def descartaveis_key_words
        ['papel higiênico', 'lixo', 'guardanapo', 'guardanapos', 'papel toalha', 'papel absorvente', 'lenço de papel',
         'lenços de papel', 'pilha', 'bateria', 'fósforo', 'embalagem', 'filtro de café', 'descartável', 'descartáveis', 'canudo',
         'papel manteiga', 'papel alumínio', 'filme pvc', 'vela', 'bexiga', 'organizador de alimentos', 'sacola plastica', 'sacola plástica', 'saco plastico', 'saco plástico', 'sacos plasticos', 'sacos plásticos', 'saco para cubos de gelo'
        ]
      end

      def queijos_e_frios_key_words
        ['queijo', 'requeijão', 'presunto', 'parmesão', 'salame', 'cream cheese', 'mussarela', 'muçarela', 'mortadela', 'ricota',
         'copa', 'peito de peru'
        ]
      end

      def higiene_key_words
        ['shampoo', 'sabonete', 'desodorante', 'condicionador', 'loção', 'cabelo', 'protetor solar', 'espuma de barbear',
         'creme de barbear', 'creme depilatório', 'talco', 'cera', 'menstrual', 'menstruação', 'colgate', 'sorriso', 'closeup',
         'close up', 'alvejante', 'repelente', 'aborvente', 'absorvente', 'absovente', 'vanish', 'sbp', 'bom ar', 'aguarrás',
         'álcool', 'alcool', 'escova de dente'
        ]
      end

      def hortifruti_key_words
        ['tempero', 'erva', 'especiaria', 'alface', 'tomate', 'uva', 'fruta', 'legume', 'batata', 'verdura', 'salada', 'cebola',
         'banana', 'tapioca', 'laranja', 'maça', 'pepino',  'alho', 'cogumelo', 'castanha', 'farinha', 'lilnhaça', 'alcachofra',
         'ameixa', 'amêndoa', 'brócolis', 'limão', 'pera', 'pimentão', 'abobrinha', 'abóbora', 'beterraba', 'couve', 'cebolinha',
         'cenoura', 'chia', 'gergelim', 'mexerica', 'folha', 'vagem', 'espinafre', 'manga', 'maracujá', 'melão', 'azeitona',
         'abacate', 'abacaxi', 'abobora', 'abóbora', 'morango', 'acelga', 'agriao', 'agrião', 'vegetal', 'vegetais', 'aipim',
         'mandioquinha', 'macaxeira', 'macaxera', 'figo'
        ]
      end

      def mercearia_key_words
        ['arroz', 'feijão', 'óleo', 'azeite', 'pão', 'pãezinhos', 'bisnaguinha', 'molho de tomate', 'macarrão', 'espaguete', 'penne',
         'pipoca', 'milho', 'ervilha', 'palmito', 'pimenta', 'shoyu', 'pastel', 'aceto', 'quinoa', 'grão de bico', 'lentilha',
         'açafrão', 'wrap', 'xarope', 'achocolatado', 'vinagre', 'açucar', 'açúcar', 'adoçante', 'tosta', 'tostata', 'trigo',
         'torrada'
        ]
      end

      def beleza_key_words
        ['1ka', 'ykas', 'zap', 'yellow ye', 'yellow kit', 'yellow profissional', 'yellow new', 'yellow form', 'yellow ativador',
         'zero nó', 'ybera', 'bronzeado', 'protetor solar', 'wella', 'hidratante', 'lola cosmetics', "victoria's secret", 'truss',
         'agilise', 'advance techniques', 'adstringente', 'siàge', 'haskell', 'senscience', 'esfoliante', 'alfaparf'
        ]
      end

      def utensilios_key_words
        ['bolas pvc para massagem', 'abridor de lata', 'taça', 'copo', 'vassoura', 'pá', 'rodo', 'acendedor', 'wahl', 'varal',
         'tv led', 'adaptador', 'touca', 'gama italy', 'esponja', 'filtro de papel', 'lã de aço', 'bombril', 'liquidificador',
         'prendedor de roupa' ,'escova', 'barbante', 'isqueiro', 'pano de prato', 'espeto', 'tigela', 'espremedor', 'super bonder',
         'tramontina', 'saca rolha', 'saca rolhas', 'protetor de mesa', 'jarra', 'pote', 'assadeira', 'forma'
        ]
      end

      def outros_key_words
        ['whey', 'v6', 'vaselina', 'vegetariano', 'albumina', 'midway', 'lampada', 'lâmpada', 'toalha', 'chinelo', 'sandalia',
         'sandália', 'cola universal', 'regulador de pressão', 'panela de pressão', 'barbuche', 'caneta'
        ]
      end
    end
  end
end
