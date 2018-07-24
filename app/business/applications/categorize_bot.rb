module Applications
  class CategorizeBot
    class << self
      def categorize
      end

      private

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
