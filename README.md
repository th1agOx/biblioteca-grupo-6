# 📚 Biblioteca — Grupo 6

Atividade prática da disciplina de **Banco de Dados**, com foco em modelagem conceitual, lógica e física de um sistema de empréstimo de livros.

---

## Sobre o projeto

O banco de dados simula um sistema de empréstimo de livros, contemplando o relacionamento entre autores, livros, usuários e registros de empréstimo.

---

## Modelagem

O projeto inclui os três níveis de modelagem:

- **Conceitual** — diagrama de entidade-relacionamento (DER)
- **Lógico** — estrutura das tabelas e seus relacionamentos
- **Físico** — scripts SQL com criação das tabelas, inserção de dados e queries

---

## Estrutura do banco

| Tabela | Descrição |
|---|---|
| `autor` | Armazena os autores dos livros |
| `livro` | Cada livro vinculado a um autor |
| `usuario` | Usuários que realizam empréstimos |
| `emprestimo` | Registro dos empréstimos realizados |

### Integridade referencial

- Ao excluir um autor, todos os seus livros são excluídos automaticamente (`ON DELETE CASCADE`)
- Atualização do `id_autor` é bloqueada caso existam livros vinculados (`ON UPDATE RESTRICT`)

---

## Queries implementadas

1. Livros que foram emprestados
2. Livros que **não** foram emprestados
3. Contagem total de livros emprestados
4. Quantidade de livros por autor
5. Livros ordenados do mais caro ao mais barato
6. Exclusão de autor com remoção automática dos seus livros
7. Total arrecadado em empréstimos de um determinado livro

---

## Disciplina

Disciplina Banco de Dados — Grupo 6
