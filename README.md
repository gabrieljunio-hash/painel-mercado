# Mercado Claro

Painel brasileiro de mercados financeiros e agronegócio, com simulador de juros compostos.

## Funcionalidades atuais
- Cotação USD/BRL via AwesomeAPI, com tratamento de falhas.
- Gráficos incorporados pelo TradingView para índices, moedas, commodities globais, agro e cripto.
- Simulador de juros compostos e gráfico de evolução estimada.
- Links para referências externas de café, soja e boi gordo.
- Interface responsiva e aviso de que o conteúdo não é recomendação financeira.

## Limitações atuais — importantes
- Os preços de café, soja e boi **não são importados automaticamente**; os cards abrem fontes externas.
- Símbolos e disponibilidade dos gráficos dependem do provedor e podem não renderizar em todos os mercados.
- Não há cadastro funcional, backend conectado, alertas em segundo plano, assinatura ou pagamento ativo.
- Não existe provedor autorizado de dados agro configurado.
- Não publique tokens privados no HTML. GitHub Pages serve arquivos estáticos e não executa backend.

## Arquivos
- `index.html`: frontend estático.
- `supabase/schema.sql`: esquema inicial para perfis, favoritos, alertas, painéis, simulações salvas e cotações, com políticas de acesso por usuário (RLS).

## Preparação do backend
1. Crie um projeto Supabase e configure Auth, domínio e URLs de retorno.
2. Em projeto novo, revise e execute `supabase/schema.sql` no SQL Editor.
3. Teste as políticas RLS com duas contas distintas antes de armazenar dados reais.
4. Escolha um fornecedor de cotações e valide licença, preço, atraso permitido, unidades, limites e direito de redistribuição.
5. Implemente uma função server-side para importar cotações; guarde credenciais privadas em secrets.
6. Configure uma rotina agendada para atualizar cotações e verificar alertas.
7. Escolha um gateway de pagamentos e valide webhooks no servidor antes de liberar Premium.
8. Adicione testes automatizados, monitoramento, política de privacidade e termos antes de uso comercial.

## Checklist do roadmap
- [x] Frontend estático publicado
- [x] Cotação USD/BRL com tratamento de falha
- [x] Gráficos incorporados
- [x] Simulador de juros compostos
- [x] Referências externas para café, soja e boi
- [x] Esquema inicial de banco e políticas RLS
- [ ] Criar e configurar projeto Supabase real
- [ ] Conectar login/cadastro e testar autorização
- [ ] Escolher fonte de dados com licença adequada
- [ ] Importar cotações agro e guardar histórico
- [ ] Backend/API, cache, limites e recuperação de falhas
- [ ] Favoritos e painéis sincronizados por conta
- [ ] Alertas agendados e notificações
- [ ] Pagamentos, webhooks e controle de assinatura
- [ ] Testes automatizados, segurança, acessibilidade e monitoramento
- [ ] Validar hospedagem e condições de uso comercial

## Referências técnicas
- GitHub Pages: https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages
- Supabase Auth: https://supabase.com/docs/guides/auth
- Supabase billing/quotas: https://supabase.com/docs/guides/platform/billing-on-supabase

Itens pendentes que dependem de credenciais, fornecedores ou configuração externa não devem ser apresentados como se estivessem funcionando.
