# Mercado Claro

Painel brasileiro de mercados financeiros e agronegócio, com simulador de juros compostos.

## Funcionalidades atuais
- Cotação USD/BRL via AwesomeAPI, com tratamento de falhas.
- Gráficos incorporados pelo TradingView para índices, moedas, commodities globais, agro e cripto.
- Simulador de juros compostos e gráfico de evolução estimada.
- Links para referências externas de café, soja e boi gordo.

## Limitações atuais
- Os preços de café, soja e boi não são importados automaticamente; os cards abrem fontes externas.
- Não há cadastro funcional, backend conectado, alertas em segundo plano, assinatura ou pagamento ativo.
- GitHub Pages hospeda arquivos estáticos e não executa backend. Não coloque credenciais privadas no HTML.

## Arquivos
- `index.html`: página inicial.
- `mercados.html`: gráficos de mercados financeiros.
- `agro.html`: painel geral de agronegócio.
- `cafe.html`, `soja.html`, `boi-gordo.html`: páginas específicas com contexto, gráficos e fontes de cotação.
- `simulador.html`: simulador de juros compostos.
- `sitemap.xml` e `robots.txt`: suporte básico ao rastreamento por buscadores.
- `supabase/schema.sql`: esquema inicial para perfis, favoritos, alertas, painéis, simulações e cotações com RLS.

## SEO e conteúdo
- Cada funcionalidade principal tem uma página própria com título, descrição e URL canônica.
- O sitemap lista as páginas públicas; a indexação depende dos rastreadores e pode ser acompanhada no Google Search Console.
- As páginas de commodities explicam diferenças entre preço físico e contrato futuro e encaminham para fontes originais; os valores físicos ainda não são importados automaticamente.

## Próximos passos
1. Criar e configurar projeto Supabase, Auth e URLs de retorno.
2. Revisar e executar o SQL em um projeto novo; testar as políticas com contas diferentes.
3. Escolher fonte de cotações com licença de redistribuição adequada, unidades e horários definidos.
4. Implementar função server-side para importar cotações e rotinas agendadas para alertas.
5. Escolher gateway de pagamentos e validar webhooks no servidor antes de ativar Premium.
6. Adicionar testes automatizados, política de privacidade, termos e monitoramento.

Documentação: [GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages) · [Supabase Auth](https://supabase.com/docs/guides/auth) · [Supabase RLS](https://supabase.com/docs/guides/database/postgres/row-level-security)
