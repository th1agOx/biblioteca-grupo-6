📚 Biblioteca — Grupo 6
Atividade prática da disciplina de Banco de Dados, com foco em modelagem conceitual, lógica e física de um sistema de empréstimo de livros.

Sobre o projeto
O banco de dados simula um sistema de empréstimo de livros, contemplando o relacionamento entre autores, livros, usuários e registros de empréstimo.

Modelagem
O projeto inclui os três níveis de modelagem:

Conceitual — diagrama de entidade-relacionamento (DER)
Lógico — estrutura das tabelas e seus relacionamentos
Físico — scripts SQL com criação das tabelas, inserção de dados e queries


Estrutura do banco
TabelaDescriçãoautorArmazena os autores dos livroslivroCada livro vinculado a um autorusuarioUsuários que realizam empréstimosemprestimoRegistro dos empréstimos realizados
Integridade referencial

Ao excluir um autor, todos os seus livros são excluídos automaticamente 
Atualização do id_autor é bloqueada caso existam livros vinculados


Queries implementadas

Livros que foram emprestados
Livros que não foram emprestados
Contagem total de livros emprestados
Quantidade de livros por autor
Livros ordenados do mais caro ao mais barato
Exclusão de autor com remoção automática dos seus livros
Total arrecadado em empréstimos de um determinado livro


Disciplina
Banco de Dados — Grupo 6
