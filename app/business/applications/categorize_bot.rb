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

          puts "#{product.name} CATEGORIZADO" if product.category
          puts "ERRO AO CATEGORIZAR PRODUTO #{product.name}" if product.category.nil?
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

      def acougue_key_words
        ['salsicha', 'linguiça', 'frango', 'costela', 'bovina', 'bovino', 'charque', 'contra filé', 'camarão', 'bacon', 'carne',
         'sobrecoxa', 'hambúrguer', 'asa', 'coxa', 'bacalhau', 'sardinha', 'kani', 'peixe', 'espinha', 'linguado',
         'abadejo', 'coração', 'tilápia', 'merluza', 'salmão', 'lagosta', 'mexilhão', 'porco', 'lombo', 'suíno', 'suína' 'lula',
         'polvo', 'picanha', 'alcatra', 'maminha', 'kafta', 'maturatta', 'pato', 'fraldinha', 'asinha', 'acém', 'pernil', 'chorizo',
         'paio'
        ]
      end

      def bebidas_key_words
        ['coca', 'cocacola', 'coca-cola' 'água', 'dolce', 'solúvel', 'energético', 'espresso', 'isotônico', 'nescau', 'suco', 'nectar',
         'chá',  'fanta', 'guaraná', 'leite', 'café', 'toddynho', 'kuat', 'refrigerante', 'toddy', 'refresco', 'bebida', 'schweppes',
         'sprite', 'ades', 'h2oh', 'h2oh!', 'pepsi', 'gatorade'
        ]
      end

      def bebidas_alcoolicas_key_words
        ['cerveja', 'vodka', 'whisky', 'catuaba', 'vinho', 'espumante', 'licor', 'saque', 'saquê', 'cachaça', 'conhaque',
         'tequila', 'aperol', 'rum', 'gin', 'champagne'
        ]
      end

      def doces_key_words
        ['bombom', 'bomboms', 'chocolate', 'condensado', 'sorvete', 'gelatina', 'geléia', 'bolo', 'bala', 'balas', 'panetone' 'chichlete',
         'chicletes', 'creme de leite', 'bis', 'goiabada', 'doce', 'doces', 'paçoca', 'creme de avelã', 'chantily', 'confeito',
         'confeitos', 'granulado', 'granulados', 'cobertura', 'marshmallow', 'mel', 'páscoa', 'pão de mel', 'alfajor', 'flan',
         'brigadeiro', 'cocada', 'confeitaria', 'fondant', 'pé de moleque', 'mousse'
        ]
      end

      def congelados_key_words
        ['açai', 'nugget', 'nuggets', 'pão de queijo', 'pizza', 'congelado', 'congelada']
      end

      def descartaveis_key_words
        ['papel higiênico', 'lixo', 'guardanapo', 'guardanapos', 'papel toalha', 'papel absorvente', 'lenço de papel',
         'lenços de papel', 'pilha', 'pilhas', 'bateria', 'baterias', 'fósforo', 'fósforos', 'embalagem', 'embalagens', 'filtro de café',
         'descartável', 'descartáveis', 'canudo', 'canudos', 'papel manteiga', 'papel alumínio', 'filme pvc', 'vela', 'velas', 'bexiga',
         'bexigas'
        ]
      end

      def queijos_e_frios_key_words
        ['queijo', 'queijos', 'requeijão', 'presunto', 'parmesão', 'salame', 'cream cheese', 'mussarela', 'muçarela',
         'mortadela', 'ricota', 'copa', 'peito de peru'
        ]
      end

      def higiene_key_words
        ['shampoo', 'sabonete', 'sabonetes', 'desodorante', 'desodorantes', 'condicionador', 'loção', 'cabelo', 'protetor solar',
         'espuma de barbear', 'creme de barbear', 'creme depilatório', 'talco', 'cera', 'menstrual', 'menstruação'
        ]
      end

      def hortifruti_key_words
        ['temperos', 'tempero', 'erva', 'ervas', 'especiaria', 'especiarias', 'alface', 'tomate', 'uva', 'fruta', 'frutas', 'legume',
         'legumes', 'batata', 'verdura', 'verduras', 'salada', 'saladas', 'cebola', 'banana', 'tapioca', 'laranja', 'maça', 'pepino',
         'alho', 'cogumelo', 'cogumelos', 'castanha', 'farinha', 'farinhas', 'lilnhaça', 'alcachofra', 'ameixa', 'amêndoa', 'amêndoas',
         'brócolis', 'limão', 'pera', 'pimentão', 'abobrinha', 'abóbora', 'beterraba', 'couve', 'cebolinha', 'cenoura', 'chia',
         'gergelim', 'mexerica', 'folha', 'folhas', 'vagem', 'espinafre', 'manga', 'maracujá', 'melão', 'azeitona', 'azeitonas'
        ]
      end

      def mercearia_key_words
        ['arroz', 'feijão', 'óleo', 'azeite', 'pão', 'pãezinhos', 'bisnaguinha', 'molho de tomate', 'macarrão', 'espaguete', 'penne',
         'pipoca', 'milho', 'ervilha', 'palmito', 'palmitos', 'pimenta', 'shoyu', 'pastel', 'aceto', 'quinoa', 'grão de bico', 'lentilha'
        ]
      end
    end
  end
end
